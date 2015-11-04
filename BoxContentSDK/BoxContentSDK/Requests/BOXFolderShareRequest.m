//
//  BOXFolderShareRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderShareRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"

@interface BOXFolderShareRequest ()

@property (nonatomic, readwrite, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) BOOL shouldUseCanDownload;
@property (nonatomic, readwrite, assign) BOOL shouldUseCanPreview;

@end

@implementation BOXFolderShareRequest

@synthesize canDownload = _canDownload;
@synthesize canPreview = _canPreview;

- (instancetype)initWithFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        _folderID = folderID;
    }

    return self;
}

- (void)setCanDownload:(BOOL)canDownload
{
    self.shouldUseCanDownload = YES;

    _canDownload = canDownload;
}

- (void)setCanPreview:(BOOL)canPreview
{
    self.shouldUseCanPreview = YES;

    _canPreview = canPreview;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:nil
                                 subID:nil];

    NSMutableDictionary *sharedLinkDictionary = [NSMutableDictionary dictionary];

    if ([self.accessLevel length] > 0 || self.expirationDate != nil || self.shouldUseCanDownload || self.shouldUseCanPreview || self.removeExpirationDate) {

        if ([self.accessLevel length] > 0) {
            sharedLinkDictionary[BOXAPIObjectKeyAccess] = self.accessLevel;
        } else {
            sharedLinkDictionary[BOXAPIObjectKeyAccess] = [NSNull null];
        }

        if (self.removeExpirationDate) {
            sharedLinkDictionary[BOXAPIObjectKeyUnsharedAt] = [NSNull null];
        } else if (self.expirationDate != nil) {
            sharedLinkDictionary[BOXAPIObjectKeyUnsharedAt] = [self.expirationDate box_ISO8601String];
        }

        if (self.shouldUseCanDownload || self.shouldUseCanPreview) {
            NSMutableDictionary *permissionsDictionary = [NSMutableDictionary dictionary];

            if (self.shouldUseCanDownload) {
                permissionsDictionary[BOXAPIObjectKeyCanDownload] = [NSNumber numberWithBool:self.canDownload];
            }

            if (self.shouldUseCanPreview) {
                permissionsDictionary[BOXAPIObjectKeyCanPreview] = [NSNumber numberWithBool:self.canPreview];
            }
            [sharedLinkDictionary setObject:permissionsDictionary forKey:BOXAPIObjectKeyPermissions];
        }
    }
    NSDictionary *bodyDictionary = @{BOXAPIObjectKeySharedLink: sharedLinkDictionary};
    
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
