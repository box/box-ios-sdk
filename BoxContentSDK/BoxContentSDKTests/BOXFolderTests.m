//
//  BOXFolderTests
//  BoxContentSDK
//

#import "BOXModelTestCase.h"
#import "BOXFolder.h"
#import "BOXFile.h"
#import "BOXUser.h"
#import "BOXBookmark.h"
#import "BOXCollection.h"
#import "BOXMetadata.h"

@interface BOXFolderTests : BOXModelTestCase
@end

@implementation BOXFolderTests

- (void)test_that_mini_folder_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"folder_mini_fields"];
    BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"123", folder.modelID);
    XCTAssertEqualObjects(@"My first sub-folder", folder.name);
    XCTAssertEqualObjects(@"0", folder.etag);
    XCTAssertEqualObjects(@"0", folder.sequenceID);
    XCTAssertFalse(folder.isFile);
    XCTAssertTrue(folder.isFolder);
    XCTAssertFalse(folder.isBookmark);
}

- (void)test_that_folder_with_default_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"folder_default_fields"];
    BOXFolder *folder = [[BOXFolder alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"2759406491", folder.modelID);
    XCTAssertEqualObjects(@"bookmarks yo", folder.name);
    XCTAssertEqualObjects(@"0", folder.etag);
    XCTAssertEqualObjects(@"0", folder.sequenceID);
    XCTAssertEqualObjects(@"", folder.itemDescription);

    NSNumber *folderSize = [NSNumber numberWithInteger:0];
    XCTAssertEqualObjects(folderSize, folder.size);

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:18:33-08:00"], folder.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:18:33-08:00"], folder.modifiedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:18:33-08:00"], folder.contentCreatedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:18:33-08:00"], folder.contentModifiedDate);

    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(1, folder.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *miniFolder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *parentFolder = folder.pathFolders[i];
        [self assertModel:miniFolder isEquivalentTo:parentFolder];
        XCTAssertEqualObjects(@"0", parentFolder.modelID);
    }

    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];

    [self assertModel:creator isEquivalentTo:folder.creator];
    XCTAssertEqualObjects(@"15220407", folder.creator.modelID);

    [self assertModel:modifier isEquivalentTo:folder.lastModifier];
    XCTAssertEqualObjects(@"15220407", folder.lastModifier.modelID);

    [self assertModel:owner isEquivalentTo:folder.owner];
    XCTAssertEqualObjects(@"15220407", folder.owner.modelID);

    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:folder.parentFolder];
    XCTAssertEqualObjects(@"0", folder.parentFolder.modelID);

    XCTAssertEqualObjects(@"active", folder.status);
    XCTAssertEqualObjects(nil, folder.folderUploadEmailAccess);
    XCTAssertEqualObjects(nil, folder.folderUploadEmailAddress);

    XCTAssertNil(folder.allowedSharedLinkAccessLevels);
    XCTAssertNil(folder.syncState);

    XCTAssertEqual(BOXAPIBooleanUnknown, folder.hasCollaborations);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canDownload);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canUpload);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canRename);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canDelete);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canShare);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canInviteCollaborator);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canSetShareAccess);
    XCTAssertEqual(BOXAPIBooleanUnknown, folder.canNonOwnersInvite);
    
    XCTAssertFalse(folder.isFile);
    XCTAssertTrue(folder.isFolder);
    XCTAssertFalse(folder.isBookmark);

    XCTAssertEqual(folder.metadata.count, 0);
}

- (void)test_that_folder_with_missing_default_invitee_role_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"folder_all_fields"];

    // manually strip the 'default_invitee_role' entry
    NSMutableDictionary *mutable = [dictionary mutableCopy];
    [mutable removeObjectForKey:@"default_invitee_role"];

    BOXFolder *folder = [[BOXFolder alloc] initWithJSON:mutable];
    XCTAssertEqual(folder.defaultInviteeRole, nil);
}

- (void)test_that_folder_with_nsnull_default_invitee_role_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"folder_with_null_default_collab_invitee"];
        
    BOXFolder *folder = [[BOXFolder alloc] initWithJSON:dictionary];
    XCTAssertEqual(folder.defaultInviteeRole, nil);
}

- (void)test_that_folder_with_all_fields_is_parsed_correctly_from_json
{
    // TODO: We need to revisit folder_all_fields to make sure it reflects the latest server API doc.
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"folder_all_fields"];
    BOXFolder *folder = [[BOXFolder alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"2759406491", folder.modelID);
    XCTAssertEqualObjects(@"bookmarks yo", folder.name);
    XCTAssertEqualObjects(@"0", folder.etag);
    XCTAssertEqualObjects(@"0", folder.sequenceID);
    XCTAssertEqualObjects(@"", folder.itemDescription);
    
    NSNumber *folderSize = [NSNumber numberWithLong:16096676];
    XCTAssertEqualObjects(folderSize, folder.size);
    
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:18:33-08:00"], folder.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T17:37:43-08:00"], folder.modifiedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:18:33-08:00"], folder.contentCreatedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T17:37:43-08:00"], folder.contentModifiedDate);
    
    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(1, folder.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *miniFolder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *parentFolder = folder.pathFolders[i];
        [self assertModel:miniFolder isEquivalentTo:parentFolder];
        XCTAssertEqualObjects(@"0", parentFolder.modelID);
    }
    
    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];
    
    [self assertModel:creator isEquivalentTo:folder.creator];
    XCTAssertEqualObjects(@"15220407", folder.creator.modelID);
    
    [self assertModel:modifier isEquivalentTo:folder.lastModifier];
    XCTAssertEqualObjects(@"15220407", folder.lastModifier.modelID);
    
    [self assertModel:owner isEquivalentTo:folder.owner];
    XCTAssertEqualObjects(@"15220407", folder.owner.modelID);
    
    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:folder.parentFolder];
    XCTAssertEqualObjects(@"0", folder.parentFolder.modelID);
    
    XCTAssertEqualObjects(@"active", folder.status);
    XCTAssertEqualObjects(@"collaborators", folder.folderUploadEmailAccess);
    XCTAssertEqualObjects(@"bilbo.baggins@gmail.com", folder.folderUploadEmailAddress);

    NSArray *accessLevels = @[@"collaborators", @"open"];
    XCTAssertEqualObjects(accessLevels, folder.allowedSharedLinkAccessLevels);
    XCTAssertEqualObjects(@"not_synced", folder.syncState);

    XCTAssertEqual(BOXAPIBooleanNO, folder.hasCollaborations);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canDownload);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canUpload);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canRename);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canDelete);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canShare);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canInviteCollaborator);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canSetShareAccess);
    XCTAssertEqual(BOXAPIBooleanYES, folder.canNonOwnersInvite);
    
    NSArray *collectionsJSON = dictionary[BOXAPIObjectKeyCollections];
    NSMutableArray *expectedCollections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];
    for (NSDictionary *dict in collectionsJSON) {
        [expectedCollections addObject:[[BOXCollection alloc] initWithJSON:dict]];
    }
    
    XCTAssertEqual(folder.collections.count, expectedCollections.count);
    
    for (NSUInteger i = 0; i < folder.collections.count ; i++) {
        [self assertModel:folder.collections[i] isEquivalentTo:expectedCollections[i]];
    }
    
    XCTAssertFalse(folder.isFile);
    XCTAssertTrue(folder.isFolder);
    XCTAssertFalse(folder.isBookmark);

    XCTAssertEqual(folder.metadata.count, 1);
    BOXMetadata *metadata = folder.metadata[0];
    XCTAssertEqualObjects(@"yes", metadata.info[@"contentApproved"]);
    
    NSArray *allowedInviteeRoles = @[@"editor", @"viewer"];
    XCTAssertEqualObjects(allowedInviteeRoles, folder.allowedInviteeRoles);
    XCTAssertEqualObjects(folder.defaultInviteeRole, @"viewer");
}

@end

