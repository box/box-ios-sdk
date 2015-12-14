//
//  BOXItem.m
//  BoxContentSDK
//

#import "BOXItem.h"

#import "BOXFolder.h"
#import "BOXUser.h"
#import "BOXSharedLink.h"
#import "BOXCollection.h"

@implementation BOXItemMini

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super initWithJSON:JSONResponse]) {
        self.sequenceID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySequenceID
                                                         inDictionary:JSONResponse
                                                      hasExpectedType:[NSString class]
                                                          nullAllowed:YES // root folders have no sequence id
                                                    suppressNullAsNil:YES];
        
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.etag = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyETag
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:YES // root folders have no ETags
                                              suppressNullAsNil:YES];
    }
    return self;
}

- (BOOL)isFile
{
    return NO;
}

- (BOOL)isFolder
{
    return NO;
}

- (BOOL)isBookmark
{
    return NO;
}

@end

@implementation BOXItem

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super initWithJSON:JSONResponse]) {
        self.sequenceID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySequenceID
                                                         inDictionary:JSONResponse
                                                      hasExpectedType:[NSString class]
                                                          nullAllowed:YES // root folders have no sequence id
                                                    suppressNullAsNil:YES];
        
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.etag = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyETag
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:YES // root folders have no ETags
                                              suppressNullAsNil:YES];
        
        // Parse various time stamps.
        NSString *createdDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                               inDictionary:JSONResponse
                                                            hasExpectedType:[NSString class]
                                                                nullAllowed:YES // root folders have no timestamps
                                                          suppressNullAsNil:YES];
        self.createdDate = [NSDate box_dateWithISO8601String:createdDate];
        
        NSString *modifiedDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedAt
                                                                inDictionary:JSONResponse
                                                             hasExpectedType:[NSString class]
                                                                 nullAllowed:YES // root folders have no timestamps
                                                           suppressNullAsNil:YES];
        self.modifiedDate = [NSDate box_dateWithISO8601String:modifiedDate];
        
        NSString *contentCreateDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyContentCreatedAt
                                                                     inDictionary:JSONResponse
                                                                  hasExpectedType:[NSString class]
                                                                      nullAllowed:YES // root folders have no timestamps
                                                                suppressNullAsNil:YES];
        self.contentCreatedDate = [NSDate box_dateWithISO8601String:contentCreateDate];
        
        NSString *contentModifiedDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyContentModifiedAt
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSString class]
                                                                        nullAllowed:YES // root folders have no timestamps
                                                                  suppressNullAsNil:YES];
        self.contentModifiedDate = [NSDate box_dateWithISO8601String:contentModifiedDate];
        
        NSString *trashedDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyTrashedAt
                                                               inDictionary:JSONResponse
                                                            hasExpectedType:[NSString class]
                                                                nullAllowed:YES // root folders have no timestamps
                                                          suppressNullAsNil:YES];
        self.trashedDate = [NSDate box_dateWithISO8601String:trashedDate];
        
        NSString *purgedDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyPurgedAt
                                                              inDictionary:JSONResponse
                                                           hasExpectedType:[NSString class]
                                                               nullAllowed:YES // root folders have no timestamps
                                                         suppressNullAsNil:YES];
        self.purgedDate = [NSDate box_dateWithISO8601String:purgedDate];
        
        // Parse File Description.
        self.itemDescription = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDescription
                                                              inDictionary:JSONResponse
                                                           hasExpectedType:[NSString class]
                                                               nullAllowed:NO];
        
        // Parse Path Folders.
        NSDictionary *pathCollectionJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyPathCollection
                                                                          inDictionary:JSONResponse
                                                                       hasExpectedType:[NSDictionary class]
                                                                           nullAllowed:NO];
        NSArray *pathFolders = pathCollectionJSON[BOXAPICollectionKeyEntries];
        NSMutableArray *tempPathFolders = [NSMutableArray array];
        
        for (NSDictionary *folderJson in pathFolders) {
            BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:folderJson];
            [tempPathFolders addObject:folder];
        }
        self.pathFolders = [NSArray arrayWithArray:tempPathFolders];
        
        // Parse Creator.
        NSDictionary *creatorJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedBy
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:YES
                                                              suppressNullAsNil:YES];
        if (creatorJSON) {
            self.creator = [[BOXUserMini alloc] initWithJSON:creatorJSON];
        }
        
        // Parse Last Modifier.
        NSDictionary *modifierJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedBy
                                                                    inDictionary:JSONResponse
                                                                 hasExpectedType:[NSDictionary class]
                                                                     nullAllowed:YES
                                                               suppressNullAsNil:YES];
        if (modifierJSON) {
            self.lastModifier = [[BOXUserMini alloc] initWithJSON:modifierJSON];
        }
        
        // Parse Owner.
        NSDictionary *ownerJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyOwnedBy
                                                                 inDictionary:JSONResponse
                                                              hasExpectedType:[NSDictionary class]
                                                                  nullAllowed:NO];
        if (ownerJSON) {
            self.owner = [[BOXUserMini alloc] initWithJSON:ownerJSON];
        }
        
        // Parse Parent Folder.
        id parentJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyParent
                                                       inDictionary:JSONResponse
                                                    hasExpectedType:[NSDictionary class]
                                                        nullAllowed:YES];
        if (parentJSON != nil) {
            if ([parentJSON isKindOfClass:[NSNull class]]) {
                self.parentFolder = nil;
            }
            else {
                self.parentFolder = [[BOXFolderMini alloc] initWithJSON:(NSDictionary *)parentJSON];
            }
        }
        
        // Parse Status.
        self.status = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyItemStatus
                                                     inDictionary:JSONResponse
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        // Parse Shared Link.
        NSDictionary *sharedLinkJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySharedLink
                                                                      inDictionary:JSONResponse
                                                                   hasExpectedType:[NSDictionary class]
                                                                       nullAllowed:YES];
        if (sharedLinkJSON != nil && [sharedLinkJSON isEqual:[NSNull null]] == NO) {
            self.sharedLink = [[BOXSharedLink alloc] initWithJSON:sharedLinkJSON];
        }
        
        // Parse Shared Link Access Levels.
        self.allowedSharedLinkAccessLevels = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyAllowedSharedLinkAccessLevels
                                                                            inDictionary:JSONResponse
                                                                         hasExpectedType:[NSArray class]
                                                                             nullAllowed:NO];
        
        // Parse Item Size.
        self.size = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySize
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSNumber class]
                                                    nullAllowed:NO];
        
        NSArray *collectionsJSONArray = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCollections 
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSArray class]
                                                                        nullAllowed:YES];
        NSMutableArray *collections = [NSMutableArray arrayWithCapacity:collectionsJSONArray.count];
        for (NSDictionary *dict in collectionsJSONArray) {
            [collections addObject:[[BOXCollection alloc] initWithJSON:dict]];
        }
        self.collections = collections;
        
    }
    return self;
}

- (BOOL)isFile
{
    return NO;
}

- (BOOL)isFolder
{
    return NO;
}

- (BOOL)isBookmark
{
    return NO;
}

@end
