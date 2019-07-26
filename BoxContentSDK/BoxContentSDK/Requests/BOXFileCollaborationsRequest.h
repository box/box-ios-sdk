//
//  BOXFileCollaborationsRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXFileCollaborationsRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *fileID;

/**
 Number of records to fetch.
 - Minimum allowed value: 0
 - Maximum allowed value: 1000
 - Defaults to 100 (at time of writing)
 */
@property (nonatomic, readwrite, assign) NSInteger limit;

/**
 Marker of the recents record to begin the listing. Use this field when making multiple paged requests.
 For example, after requesting the first 100 records, you can provide the nextMarker to fetch another set of
 records beginning at the 101st item in the listing. The next available marker ID is returned in the response header
 of each paged recent items request.
 */
@property (nonatomic, readwrite, strong) NSString *nextMarker;

- (instancetype)initWithFileID:(NSString *)fileID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXFileCollaborationArrayCompletionBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXFileCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXFileCollaborationArrayCompletionBlock)refreshBlock;

@end
