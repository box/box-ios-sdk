//
//  BOXRequest_Private.h
//  BoxContentSDK
//

#import "BOXAPIDataOperation.h"
#import "BOXAPIJSONOperation.h"
#import "BOXAPIJSONPatchOperation.h"
#import "BOXStreamOperation.h"
#import "BOXAPIHeadOperation.h"
#import "BOXAPIOAuth2ToJSONOperation.h"

#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"
#import "BOXContentCacheClientProtocol.h"

@class BOXAPIQueueManager;

@interface BOXRequest ()

@property (nonatomic, readwrite, assign) id<BOXContentCacheClientProtocol> cacheClient;
@property (nonatomic, readwrite, strong) BOXAPIQueueManager *queueManager;
@property (nonatomic, readwrite, strong) BOXAPIOperation *operation;

- (NSURL *) URLWithResource:(NSString *)resource
                         ID:(NSString *)ID
                subresource:(NSString *)subresource
                      subID:(NSString *)subID
                    baseURL:(NSString *)baseURL;

- (NSURL *)URLWithResource:(NSString *)resource
                        ID:(NSString *)ID
               subresource:(NSString *)subresource
                     subID:(NSString *)subID;

- (NSURL *)uploadURLWithResource:(NSString *)resource
                              ID:(NSString *)ID
                     subresource:(NSString *)subresource;

- (BOXAPIJSONOperation *)JSONOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                             JSONSuccessBlock:(BOXAPIJSONSuccessBlock)successBlock
                                 failureBlock:(BOXAPIJSONFailureBlock)failureBlock;

- (BOXAPIJSONPatchOperation *)JSONPatchOperationWithURL:(NSURL *)URL
                                             HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                                  queryStringParameters:(NSDictionary *)queryParameters
                                              bodyArray:(NSArray *)bodyArray
                                       JSONSuccessBlock:(BOXAPIJSONSuccessBlock)successBlock
                                           failureBlock:(BOXAPIJSONFailureBlock)failureBlock;

- (BOXAPIDataOperation *)dataOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                                 successBlock:(BOXDownloadSuccessBlock)successBlock
                                 failureBlock:(BOXDownloadFailureBlock)failureBlock;

- (BOXAPIDataOperation *)dataOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                                 successBlock:(BOXDownloadSuccessBlock)successBlock
                                 failureBlock:(BOXDownloadFailureBlock)failureBlock
                                  associateId:(NSString *)associateId;

- (BOXStreamOperation *)dataStreamOperationWithURL:(NSURL *)URL
                                        HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                                      successBlock:(BOXDownloadSuccessBlock)successBlock
                                      failureBlock:(BOXDownloadFailureBlock)failureBlock;

- (BOXAPIHeadOperation *)headOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                                 successBlock:(BOXAPIHeaderSuccessBlock)successBlock
                                 failureBlock:(BOXAPIHeaderFailureBlock)failureBlock;

- (BOXAPIOAuth2ToJSONOperation *)authOperationWithURL:(NSURL *)URL
                                           HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                                       bodyDictionary:(NSDictionary *)bodyDictionary
                                     JSONSuccessBlock:(BOXAPIJSONSuccessBlock)successBlock
                                         failureBlock:(BOXAPIJSONFailureBlock)failureBlock;

- (BOXAPIOperation *)createOperation;

//NOTE: Only meant to be used in cases where access to the operation and its URL Session Task
// is needed before actually performing the operation. In that case, the preparation of the URL
// request and session task which is usually done right before making the network request
// (including population the API auth headers, etc) is done earlier, so it is expected that
// the operation will be enqueued immediately after and not held onto for a long time.
// Specifically it is the authentication token, which has a one hour lifespan, that gets
// associated with the operation. Thus, if a long delay is expected between setup and
// execution, it is not recommended to use this method.
- (void)prepareOperation;

- (NSString *)fullFileFieldsParameterString;
- (NSString *)fullFolderFieldsParameterString;
- (NSString *)fullBookmarkFieldsParameterString;
- (NSString *)fullItemFieldsParameterString;
- (NSString *)fullItemFieldsParameterStringExcludingFields:(NSArray *)excludedFields;
- (NSString *)fullCommentFieldsParameterString;
- (NSString *)fullUserFieldsParameterString;
- (NSString *)fullCollaborationFieldsParameterString;

- (NSString *)nonEmptyFilename:(NSString *)filename;

+ (BOXItem *)itemWithJSON:(NSDictionary *)JSONDictionary;

+ (NSArray *)itemsWithJSON:(NSDictionary *)JSONDictionary;

@end
