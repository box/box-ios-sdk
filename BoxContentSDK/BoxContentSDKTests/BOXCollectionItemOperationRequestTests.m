//
//  BOXCollectionItemOperationRequestTests.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXRequestTestCase.h"
#import "BOXCollection.h"
#import "BOXItem.h"
#import "BOXFile.h"
#import "BOXItemSetCollectionsRequest.h"
#import "BOXContentClient.h"
#import "BOXContentCacheTestClient.h"

@interface BOXCollectionItemOperationRequestTests : BOXRequestTestCase

@end

@implementation BOXCollectionItemOperationRequestTests

- (void)test_url_request_is_correct_for_addition
{
    NSData *data = [self cannedResponseDataWithName:@"file_all_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    BOXFile *file = [[BOXFile alloc] initWithJSON:dict];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceFiles, file.modelID]];
    
    BOXItemSetCollectionsRequest *itemAdditionRequest = [[BOXItemSetCollectionsRequest alloc] initFileSetCollectionsRequestForFileWithID:file.modelID collectionIDs:@[@"10047", @"1234"]];
                                                         
    XCTAssertEqualObjects(url, itemAdditionRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPUT, itemAdditionRequest.urlRequest.HTTPMethod);
    
    NSDictionary *headers = [NSJSONSerialization JSONObjectWithData:itemAdditionRequest.urlRequest.HTTPBody options:kNilOptions error:nil];
    NSArray *collectionsArray = headers[BOXAPIObjectKeyCollections];
    
    XCTAssertEqual(file.collections.count + 1, collectionsArray.count);
    
    BOOL found = NO;
    for (NSDictionary *dict in collectionsArray) {
        NSString *collectionID = dict[BOXAPIObjectKeyID];
        if ([collectionID isEqualToString:@"1234"]) {
            found = YES;
            break;
        }
    }
    XCTAssertTrue(found);
}

- (void)test_url_request_is_correct_for_deletion
{
    NSData *data = [self cannedResponseDataWithName:@"file_all_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    BOXFile *file = [[BOXFile alloc] initWithJSON:dict];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceFiles, file.modelID]];    
    BOXItemSetCollectionsRequest *itemAdditionRequest = [[BOXItemSetCollectionsRequest alloc] initFileSetCollectionsRequestForFileWithID:file.modelID collectionIDs:nil];
    
    XCTAssertEqualObjects(url, itemAdditionRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPUT, itemAdditionRequest.urlRequest.HTTPMethod);
    
    NSDictionary *headers = [NSJSONSerialization JSONObjectWithData:itemAdditionRequest.urlRequest.HTTPBody options:kNilOptions error:nil];
    NSArray *collectionsArray = headers[BOXAPIObjectKeyCollections];
    
    XCTAssertEqual(file.collections.count - 1, collectionsArray.count);
    
    BOOL found = NO;
    for (NSDictionary *dict in collectionsArray) {
        NSString *collectionID = dict[BOXAPIObjectKeyID];
        if ([collectionID isEqualToString:@"1234"]) {
            found = YES;
            break;
        }
    }
    XCTAssertFalse(found);
}

- (void)test_request_returns_correct_values
{
    NSData *data = [self cannedResponseDataWithName:@"file_all_fields"];
    NSDictionary *fileJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    BOXFile *file = [[BOXFile alloc] initWithJSON:fileJSON];
    
    BOXItemSetCollectionsRequest *additionOperationRequest =
        [[BOXItemSetCollectionsRequest alloc] initFileSetCollectionsRequestForFileWithID:file.modelID
                                                                           collectionIDs:@[@"10047"]];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    additionOperationRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    [self setCannedURLResponse:[self cannedURLResponseWithStatusCode:200 responseData:data] cannedResponseData:data forRequest:additionOperationRequest];

    [[cacheClientMock expect] cacheItemSetCollectionsRequest:additionOperationRequest
                                             withUpdatedItem:[OCMArg isNotNil]
                                                       error:[OCMArg isNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [additionOperationRequest performRequestWithCompletion:^(BOXItem *item, NSError *error) {
        XCTAssertEqual(item.collections.count, 1);
        BOXCollection *collection = [item.collections firstObject];
        XCTAssertEqualObjects(collection.modelID, @"10047");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_request_handles_error
{
    NSData *data = [self cannedResponseDataWithName:@"file_all_fields"];
    NSDictionary *fileJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    BOXFile *file = [[BOXFile alloc] initWithJSON:fileJSON];

    BOXItemSetCollectionsRequest *additionOperationRequest =
        [[BOXItemSetCollectionsRequest alloc] initFileSetCollectionsRequestForFileWithID:file.modelID
                                                                           collectionIDs:@[@"10047"]];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    additionOperationRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    [self setCannedURLResponse:[self cannedURLResponseWithStatusCode:404 responseData:nil]
            cannedResponseData:nil
                    forRequest:additionOperationRequest];

    [[cacheClientMock expect] cacheItemSetCollectionsRequest:additionOperationRequest
                                             withUpdatedItem:[OCMArg isNil]
                                                       error:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [additionOperationRequest performRequestWithCompletion:^(BOXItem *item, NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

@end
