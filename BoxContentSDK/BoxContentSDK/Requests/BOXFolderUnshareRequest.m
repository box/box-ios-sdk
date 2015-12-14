//
//  BOXFolderUnshareRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderUnshareRequest.h"

#import "BOXFolder.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXFolderUnshareRequest ()

@property (nonatomic, readwrite, strong) NSString *folderID;

@end


@implementation BOXFolderUnshareRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    self = [super init];
    if (self != nil) {
        _folderID = folderID;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:nil
                                 subID:nil];

    NSDictionary *bodyDictionary = @{BOXAPIObjectKeySharedLink: [NSNull null]};

    NSDictionary *queryParameters = @{BOXAPIParameterKeyFields: [self fullFolderFieldsParameterString]};

    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.matchingEtag length] > 0) {
        // Set up the If-Match header
        [JSONOperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }

    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];
            [self.sharedLinkHeadersHelper removeStoredInformationForItemWithID:folder.modelID itemType:folder.type];
            
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(folder, nil);
            } onMainThread:isMainThread];
        }
    };
    folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        }
    };
    
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
