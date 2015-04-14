//
//  BOXFolderRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderRequest : BOXRequestWithSharedLinkHeader

/*
 By default BOXFileRequest will fetch all fields for a particular item. You can customize which exact fields to fetch
 by passing in a field string in the format of "field1, field2, field3".
 For detailed explaination and list of the fields please visit https://developers.box.com/docs/#folders-folder-object
 */
@property (nonatomic, readwrite, assign) BOOL requestAllFolderFields;
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;//If-None-Match: Array of strings representing etag values

- (instancetype)initWithFolderID:(NSString *)folderID;
- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
