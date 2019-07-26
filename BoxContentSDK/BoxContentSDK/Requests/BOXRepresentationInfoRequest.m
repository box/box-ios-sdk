//
//  BOXRepresentationInfoRequest.m
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 4/10/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXRepresentationInfoRequest.h"
#import "BOXRequest_Private.h"
#import "BOXRepresentation.h"
#import "BOXAPIDataOperation.h"
#import "BOXLog.h"
#import "BOXDispatchHelper.h"

@interface BOXRepresentationInfoRequest ()
@property (nonatomic, readwrite, strong) BOXRepresentation *representation;
@property (nonatomic, readwrite, strong) NSString *fileID;
@end

@implementation BOXRepresentationInfoRequest

- (instancetype)initWithFileID:(NSString *)fileID
                representation:(BOXRepresentation *)representation
{
    self = [super init];
    if (self != nil) {
        _fileID = fileID;
        _representation = representation;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:self.representation.infoURL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];
    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXRepresentationInfoBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *metadataOperation = (BOXAPIJSONOperation *)self.operation;

        metadataOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                BOXRepresentation *metadata = [[BOXRepresentation alloc] initWithJSON:JSONDictionary];
                completionBlock(metadata, nil);
            } onMainThread:isMainThread];
        };

        metadataOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
