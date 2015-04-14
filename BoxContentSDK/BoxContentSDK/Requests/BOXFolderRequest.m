//
//  BOXFolderRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"
#import "BOXContentSDKConstants.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXFolderRequest ()

@property (nonatomic, readwrite, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) BOOL isTrashed;

@end

@implementation BOXFolderRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    return [self initWithFolderID:folderID isTrashed:NO];
}

- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed
{
    if (self = [super init]) {
        _folderID = folderID;
        _isTrashed = isTrashed;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSString *subresource = nil;

    if (self.isTrashed) {
        subresource = BOXAPISubresourceTrash;
    }

    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:subresource
                                 subID:nil];

    NSDictionary *queryParameters = nil;

    if (self.requestAllFolderFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFolderFieldsParameterString]};
    }

    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.notMatchingEtags count] > 0) {
        // Set up the If-None-Match header
        for (NSString *notMatchingEtag in self.notMatchingEtags) {
            [JSONoperation.APIRequest addValue:notMatchingEtag
                            forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }

    [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];

    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];
            
            [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:folder.modelID
                                                                                   itemType:folder.type
                                                                                  ancestors:folder.pathFolders];

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(folder, nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }

    [self performRequest];
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.folderID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFolder;
}


@end
