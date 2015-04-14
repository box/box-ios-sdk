//
//  BOXFolderCreateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderCreateRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"

@implementation BOXFolderCreateRequest

- (instancetype)initWithFolderName:(NSString *)folderName parentFolderID:(NSString *)parentFolderID
{
    if (self = [super init]) {
        _folderName = folderName;
        _parentFolderID = parentFolderID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    NSDictionary *bodyDictionary = @{BOXAPIObjectKeyParent : @{BOXAPIObjectKeyID : self.parentFolderID},
                                     BOXAPIObjectKeyName : self.folderName};

    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];
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
    return self.parentFolderID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFolder;
}

@end
