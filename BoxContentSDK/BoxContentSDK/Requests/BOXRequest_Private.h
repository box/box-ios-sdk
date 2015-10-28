//
//  BOXRequest_Private.h
//  BoxContentSDK
//

#import "BOXAPIDataOperation.h"
#import "BOXAPIJSONOperation.h"
#import "BOXAPIJSONPatchOperation.h"
#import "BOXDispatchHelper.h"
#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"
#import "BOXContentCacheClientProtocol.h"

@class BOXAPIQueueManager;

@interface BOXRequest ()

@property (nonatomic, readwrite, assign) id<BOXContentCacheClientProtocol> cacheClient;
@property (nonatomic, readwrite, strong) BOXAPIQueueManager *queueManager;
@property (nonatomic, readwrite, strong) BOXAPIOperation *operation;

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

- (BOXAPIOperation *)createOperation;

- (NSString *)fullFileFieldsParameterString;
- (NSString *)fullFolderFieldsParameterString;
- (NSString *)fullBookmarkFieldsParameterString;
- (NSString *)fullItemFieldsParameterString;
- (NSString *)fullCommentFieldsParameterString;
- (NSString *)fullUserFieldsParameterString;
- (NSString *)fullCollaborationFieldsParameterString;

- (NSString *)nonEmptyFilename:(NSString *)filename;

+ (BOXItem *)itemWithJSON:(NSDictionary *)JSONDictionary;

+ (NSArray *)itemsWithJSON:(NSDictionary *)JSONDictionary;

@end
