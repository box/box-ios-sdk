//
//  BOXFileRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFile.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXFileRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;
@property (nonatomic, readwrite, assign) BOOL isTrashed;

@end

@implementation BOXFileRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    return [self initWithFileID:fileID isTrashed:NO];
}

- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed
{    
    if (self = [super init]) {
        _fileID = fileID;
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
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:subresource
                                 subID:nil];

    NSDictionary *queryParameters = nil;

    if (self.requestAllFileFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};
    }

    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.notMatchingEtags count] > 0) {
        // Set up the If-None-Match header
        for (NSString *notMatchingEtag in self.notMatchingEtags) {
            [JSONOperation.APIRequest addValue:notMatchingEtag
                            forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }
    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
            
            [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:file.modelID
                                                                                   itemType:file.type
                                                                                  ancestors:file.pathFolders];

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failure =
            ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
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
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
