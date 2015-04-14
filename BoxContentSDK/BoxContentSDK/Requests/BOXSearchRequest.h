//
//  BOXSearchRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXSearchRequest : BOXRequest

@property (nonatomic, readwrite, strong) NSArray *fileExtensions;
@property (nonatomic, readwrite, strong) NSDate *createdAtFromDate;
@property (nonatomic, readwrite, strong) NSDate *createdAtToDate;
@property (nonatomic, readwrite, strong) NSDate *updatedAtFromDate;
@property (nonatomic, readwrite, strong) NSDate *updatedAtToDate;
@property (nonatomic, readwrite, assign) NSUInteger sizeLowerBound;
@property (nonatomic, readwrite, assign) NSUInteger sizeUpperBound;
@property (nonatomic, readwrite, strong) NSArray *ownerUserIDs;
@property (nonatomic, readwrite, strong) NSArray *ancestorFolderIDs;
@property (nonatomic, readwrite, strong) NSArray *contentTypes;
@property (nonatomic, readwrite, strong) NSString *type;

- (instancetype)initWithSearchQuery:(NSString *)query inRange:(NSRange)range;
- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock;

@end
