//
//  BOXCommentAddRequest.m
//  BoxContentSDK
//

#import "BOXCommentAddRequest.h"

#import "BOXItem.h"
#import "BOXComment.h"

@interface BOXCommentAddRequest ()

@property (nonatomic, readwrite, strong) NSString *modelID;
@property (nonatomic, readwrite, strong) NSString *modelType;
@property (nonatomic, readwrite, strong) NSString *message;

@end

@implementation BOXCommentAddRequest

- (instancetype)initWithModelID:(NSString *)modelID modelType:(NSString *)modelType message:(NSString *)message
{
    if (self = [super init]) {
        _modelID = modelID;
        _modelType = modelType;
        _message = message;
    }
    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID message:(NSString *)message
{
    return [self initWithModelID:fileID modelType:BOXAPIItemTypeFile message:message];
}

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID message:(NSString *)message
{
    return [self initWithModelID:bookmarkID modelType:BOXAPIItemTypeWebLink message:message];
}

- (instancetype)initWithCommentID:(NSString *)commentID message:(NSString *)message
{
    return [self initWithModelID:commentID modelType:BOXAPIItemTypeComment message:message];
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;
    
    // The model is required to perform a comment add API call.
    if (self.modelID) {
        NSURL *url = [self URLWithResource:BOXAPIResourceComments ID:nil subresource:nil subID:nil];
        
        NSMutableDictionary *objectDictionary = [NSMutableDictionary dictionary];
        objectDictionary[BOXAPIObjectKeyID] = self.modelID;
        objectDictionary[BOXAPIObjectKeyType] = self.modelType;
        
        NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
        bodyDictionary[BOXAPIObjectKeyItem] = objectDictionary;
        
        if (self.message) {
            bodyDictionary[BOXAPIObjectKeyMessage] = self.message;
        }
        
        if (self.taggedMessage) {
            bodyDictionary[BOXAPIObjectKeyTaggedMessage] = self.taggedMessage;
        }
        
        operation = [self JSONOperationWithURL:url 
                                    HTTPMethod:BOXAPIHTTPMethodPOST 
                         queryStringParameters:nil
                                bodyDictionary:bodyDictionary
                              JSONSuccessBlock:nil
                                  failureBlock:nil];
    }
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *commentAddOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        commentAddOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                BOXComment *comment = [[BOXComment alloc] initWithJSON:JSONDictionary];
                completionBlock(comment ,nil);
            } onMainThread:isMainThread];
        };
        commentAddOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

@end
