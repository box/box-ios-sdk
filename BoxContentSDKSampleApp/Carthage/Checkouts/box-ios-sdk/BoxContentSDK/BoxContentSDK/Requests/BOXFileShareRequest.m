//
//  BOXFileShareRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileShareRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFile.h"

@interface BOXFileShareRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;
@property (nonatomic, readwrite, assign) BOOL shouldUseCanDownload;
@property (nonatomic, readwrite, assign) BOOL shouldUseCanPreview;

@end

@implementation BOXFileShareRequest

@synthesize canDownload = _canDownload;
@synthesize canPreview = _canPreview;

- (instancetype)initWithFileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileID = fileID;
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
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
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

    NSDictionary *queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};
    
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

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

    fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        }
    };
    fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
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
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
