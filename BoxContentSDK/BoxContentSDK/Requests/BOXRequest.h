//
//  BOXRequest.h
//  BoxContentSDK
//

#import <UIKit/UIKit.h>
#import "NSDate+BOXContentSDKAdditions.h"

@class BOXCollaboration;
@class BOXFile;
@class BOXFolder;
@class BOXItem;
@class BOXUser;
@class BOXBookmark;
@class BOXComment;
@class BOXCollection;
@class BOXFileVersion;
@class BOXMetadata;
@class BOXEvent;
@class BOXRecentItem;
@class BOXMetadataTemplate;
@class BOXRepresentation;

typedef void (^BOXErrorBlock)(NSError *error);

typedef void (^BOXCollaborationBlock)(BOXCollaboration *collaboration, NSError *error);

typedef void (^BOXItemBlock)(BOXItem *item, NSError *error);

typedef void (^BOXFileBlock)(BOXFile *file, NSError *error);

typedef void (^BOXFolderBlock)(BOXFolder *folder, NSError *error);

typedef void (^BOXImageBlock)(UIImage *image, NSError *error);

typedef void (^BOXProgressBlock)(long long totalBytesTransferred,
                                 long long totalBytesExpectedToTransfer);

typedef void (^BOXItemArrayCompletionBlock)(NSArray <BOXItem *> *items, NSUInteger totalCount, NSRange range, NSError *error);

typedef void (^BOXItemsBlock)(NSArray <BOXItem *> *items, NSError *error);

typedef void (^BOXCollaborationArrayCompletionBlock)(NSArray <BOXCollaboration *> *collaborations, NSError *error);

typedef void (^BOXFileCollaborationArrayCompletionBlock)(NSArray <BOXCollaboration *> *collaborations, NSString *nextMarker, NSError *error);

typedef void (^BOXBookmarkBlock)(BOXBookmark *bookmark, NSError *error);

typedef void (^BOXUserBlock)(BOXUser *user, NSError *error);

typedef void (^BOXObjectsArrayCompletionBlock)(NSArray *objects, NSError *error);

typedef void (^BOXCommentBlock)(BOXComment *comment, NSError *error);

typedef void (^BOXCollectionArrayBlock)(NSArray <BOXCollection *> *collections, NSError *error);

typedef void (^BOXCollectionBlock)(BOXCollection *collection, NSError *error);

typedef void (^BOXEventsBlock)(NSArray <BOXEvent *> *events, NSString *nextStreamPosition, NSError *error);

typedef void (^BOXRecentItemsBlock)(NSArray <BOXRecentItem *> *recentItems, NSString *nextMarker, NSError *error);

typedef void (^BOXFileVersionBlock)(BOXFileVersion *fileVersion, NSError *error);

typedef void (^BOXMetadataBlock)(BOXMetadata *metadata, NSError *error);

typedef void (^BOXMetadatasBlock)(NSArray <BOXMetadata *> *metadatas, NSError *error);

typedef void (^BOXMetadataTemplatesBlock) (NSArray <BOXMetadataTemplate *>*metadataTemplates, NSError *error);

typedef void (^BOXRepresentationInfoBlock)(BOXRepresentation *representation, NSError *error);

@interface BOXRequest : NSObject

@property (nonatomic, readwrite, strong) NSString *baseURL;
@property (nonatomic, readwrite, strong) NSString *uploadBaseURL;
@property (nonatomic, readwrite, strong) NSString *userAgentPrefix;

@property (nonatomic, readonly, strong) NSURLRequest *urlRequest;

@property (nonatomic, readwrite, strong) NSString *SDKIdentifier;
@property (nonatomic, readwrite, strong) NSString *SDKVersion;

- (void)performRequest;
- (void)cancel;

@end
