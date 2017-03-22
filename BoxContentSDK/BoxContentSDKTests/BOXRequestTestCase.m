//
//  BOXRequestTestCase.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/21/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXCannedURLProtocol.h"
#import "BOXParallelAPIQueueManager.h"
#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXBookmark.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXOAuth2Session.h"
#import "BOXURLSessionManager_Private.h"

@interface BOXAPIMultipartToJSONOperation ()
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;
- (void)writeDataToOutputStream;
@end

@interface BOXRequestTestCase ()

@property (nonatomic, readwrite, strong) BOXOAuth2Session *fakeOAuth2Session;
@property (nonatomic, readwrite, strong) BOXParallelAPIQueueManager *fakeQueueManager;
@property (nonatomic, readwrite, strong) BOXURLSessionManager *fakeURLSessionManager;

@end

@implementation BOXRequestTestCase

- (void)setUp
{
    [super setUp];
    
    [NSURLProtocol registerClass:[BOXCannedURLProtocol class]];
    
    self.fakeQueueManager = [[BOXParallelAPIQueueManager alloc] init];
    self.fakeURLSessionManager = [[BOXURLSessionManager alloc] initWithProtocolClasses:@[[BOXCannedURLProtocol class]]];
    self.fakeOAuth2Session = [[BOXOAuth2Session alloc] initWithClientID:@"test_client_id"
                                                                 secret:@"test_client_secret"
                                                           queueManager:self.fakeQueueManager
						      urlSessionManager:self.fakeURLSessionManager];
    self.fakeOAuth2Session.refreshToken = @"sample_refresh_token";
    self.fakeOAuth2Session.accessToken = @"sample_access_token";
    self.fakeOAuth2Session.accessTokenExpiration = [NSDate distantFuture];
    self.fakeQueueManager.session = self.fakeOAuth2Session;
}

- (void)tearDown
{
    [BOXCannedURLProtocol reset];
    [NSURLProtocol unregisterClass:[BOXCannedURLProtocol class]];
    
    self.fakeQueueManager = nil;
    self.fakeURLSessionManager = nil;
    self.fakeOAuth2Session = nil;
    
    [super tearDown];
}

#pragma mark - canned response helpers

- (void)setCannedResponse:(BOXCannedResponse *)cannedResponse
               forRequest:(BOXRequest *)request
{
    // Route this request to our own queue manager that has a fudged OAuth session set up.
    request.queueManager = self.fakeQueueManager;
    
    id requestMock = [OCMockObject partialMockForObject:request];
    [[[[requestMock stub] andDo:^(NSInvocation *invocation) {
        [BOXCannedURLProtocol setCannedResponse:cannedResponse forRequest:request.urlRequest];
    }] andForwardToRealObject] performRequest];
}

- (void)setCannedURLResponse:(NSHTTPURLResponse *)URLResponse
          cannedResponseData:(NSData *)cannedResponseData
                  forRequest:(BOXRequest *)request
{
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    [self setCannedResponse:cannedResponse forRequest:request];
}

- (NSData *)cannedResponseDataWithName:(NSString *)cannedName {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:cannedName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

- (NSHTTPURLResponse *)cannedURLResponseWithStatusCode:(NSInteger)statusCode responseData:(NSData *)responseData
{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setObject:@"application/json" forKey:@"Content-Type"];
    if (responseData) {
        [headerFields setObject:[NSString stringWithFormat:@"%lu", (unsigned long)responseData.length] forKey:@"Content-Length"];
    }
    NSHTTPURLResponse *cannedResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://api.box.com"]
                                                                    statusCode:statusCode
                                                                   HTTPVersion:@"HTTP/1.1"
                                                                  headerFields:headerFields];
    return cannedResponse;
}

- (void)setFakeQueueManagerForRequest:(BOXRequest *)request
{
    request.queueManager = self.fakeQueueManager;
}

#pragma mark - Misc helpers

- (NSString *)stringFromInputStream:(NSInputStream *)inputStream
{
    NSMutableData *dataFromStream = [NSMutableData data];
    [inputStream open];
    uint8_t byteBuffer[4096];
    NSInteger bytesRead;
    while ((bytesRead = [inputStream read:byteBuffer maxLength:4096]) != 0) {
        if (bytesRead > 0) {
            [dataFromStream appendBytes:byteBuffer length:bytesRead];
        }
    }
    [inputStream close];
    NSString *string = [[NSString alloc] initWithData:dataFromStream encoding:NSUTF8StringEncoding];
    return string;
}

- (NSArray *)sortedMultiPartPiecesFromBodyData:(NSData *)bodyData
{
    NSString *string = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    return [self sortedMultiPartPiecesFromBodyDataString:string];
}

- (NSArray *)sortedMultiPartPiecesFromBodyDataString:(NSString *)bodyDataString
{
    NSString *boundaryString = [NSString stringWithFormat:@"--%@", BOXAPIMultipartFormBoundary];
    NSArray *array = [bodyDataString componentsSeparatedByString:boundaryString];
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];

    XCTAssertEqualObjects(@"", [array firstObject]);
    XCTAssertEqualObjects(@"--\r\n", [array lastObject]);
    array = [array subarrayWithRange:NSMakeRange(1, array.count-2)];

    return array;
}

- (NSArray *)itemsFromResponseData:(NSData *)data
{
    NSMutableArray *expectedItems = [NSMutableArray array];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *itemsArray = expectedResults[@"entries"];
    
    for (NSDictionary *itemDictionary in itemsArray) {
        NSString *itemType = [itemDictionary objectForKey:BOXAPIObjectKeyType];
        if ([itemType isEqualToString:BOXAPIItemTypeFile]) {
            [expectedItems addObject:[[BOXFile alloc] initWithJSON:itemDictionary]];
        } else if ([itemType isEqualToString:BOXAPIItemTypeFolder]) {
            [expectedItems addObject:[[BOXFolder alloc] initWithJSON:itemDictionary]];
        } else if ([itemType isEqualToString:BOXAPIItemTypeWebLink]) {
            [expectedItems addObject:[[BOXBookmark alloc] initWithJSON:itemDictionary]];
        } else {
            [expectedItems addObject:[[BOXItem alloc] initWithJSON:itemDictionary]];
        }
    }
    
    return [expectedItems copy];
}

@end
