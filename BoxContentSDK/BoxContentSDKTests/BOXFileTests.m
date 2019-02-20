//
//  BOXFileTests
//  BoxContentSDK
//

#import "BOXModelTestCase.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXContentSDKConstants.h"
#import "BOXUser.h"
#import "BOXCollection.h"
#import "BOXRepresentation.h"
#import "BOXMetadata.h"

@interface BOXFileTests : BOXModelTestCase
@end

@implementation BOXFileTests

- (void)test_that_mini_file_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_mini_fields"];
    BOXFileMini *file = [[BOXFileMini alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"123", file.modelID);
    XCTAssertEqualObjects(@"Halloweenie-3.jpg", file.name);
    XCTAssertEqualObjects(@"0", file.etag);
    XCTAssertEqualObjects(@"0", file.sequenceID);
    XCTAssertTrue(file.isFile);
    XCTAssertFalse(file.isFolder);
    XCTAssertFalse(file.isBookmark);
}

- (void)test_that_file_with_default_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_default_fields"];
    BOXFile *file = [[BOXFile alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"123", file.modelID);
    XCTAssertEqualObjects(@"Halloweenie-3.jpg", file.name);
    XCTAssertEqualObjects(@"0", file.etag);
    XCTAssertEqualObjects(@"0", file.sequenceID);
    XCTAssertEqualObjects(@"", file.itemDescription);


    NSNumber *fileSize = [NSNumber numberWithInteger:622592];
    XCTAssertEqualObjects(fileSize, file.size);

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:22-07:00"], file.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:23-07:00"], file.modifiedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:43-07:00"], file.contentCreatedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:44-07:00"], file.contentModifiedDate);

    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(1, file.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *fileFolder = file.pathFolders[i];
        [self assertModel:folder isEquivalentTo:fileFolder];
        XCTAssertEqualObjects(@"0", folder.modelID);
    }

    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];

    [self assertModel:creator isEquivalentTo:file.creator];
    XCTAssertEqualObjects(@"13338532", file.creator.modelID);

    [self assertModel:modifier isEquivalentTo:file.lastModifier];
    XCTAssertEqualObjects(@"13338532", file.lastModifier.modelID);

    [self assertModel:owner isEquivalentTo:file.owner];
    XCTAssertEqualObjects(@"13338532", file.owner.modelID);

    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:file.parentFolder];
    XCTAssertEqualObjects(@"0", file.parentFolder.modelID);


    XCTAssertEqualObjects(@"active", file.status);
    XCTAssertEqualObjects(@"f34df557706317b50ee400e072eb731032fe27d3", file.SHA1);

    XCTAssertNil(file.versionNumber);
    XCTAssertNil(file.commentCount);
    XCTAssertNil(file.extension);
    XCTAssertNil(file.lock);
    XCTAssertNil(file.allowedSharedLinkAccessLevels);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canDownload);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canPreview);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canUpload);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canComment);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canRename);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canDelete);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canShare);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.canSetShareAccess);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.isPackage);
    
    XCTAssertTrue(file.isFile);
    XCTAssertFalse(file.isFolder);
    XCTAssertFalse(file.isBookmark);
}

- (void)test_that_file_with_missing_default_invitee_role_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_all_fields"];
    
    // manually strip the 'default_invitee_role' entry
    NSMutableDictionary *mutable = [dictionary mutableCopy];
    [mutable removeObjectForKey:@"default_invitee_role"];
    
    BOXFile *file = [[BOXFile alloc] initWithJSON:mutable];
    XCTAssertEqual(file.defaultInviteeRole, nil);
}

- (void)test_that_file_with_all_fields_is_parsed_correctly_from_json
{
    // TODO: We need to revisit file_all_fields to make sure it reflects the latest server API doc.
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_all_fields"];
    BOXFile *file = [[BOXFile alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"123", file.modelID);
    XCTAssertEqualObjects(@"Halloweenie-3.jpg", file.name);
    XCTAssertEqualObjects(@"0", file.etag);
    XCTAssertNil(file.sequenceID);
    XCTAssertEqualObjects(@"", file.itemDescription);

    NSNumber *fileSize = [NSNumber numberWithInteger:622592];
    XCTAssertEqualObjects(fileSize, file.size);

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:22-07:00"], file.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:23-07:00"], file.modifiedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:43-07:00"], file.contentCreatedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:44-07:00"], file.contentModifiedDate);

    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(1, file.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *fileFolder = file.pathFolders[i];
        [self assertModel:folder isEquivalentTo:fileFolder];
    }

    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];

    [self assertModel:creator isEquivalentTo:file.creator];
    XCTAssertEqualObjects(@"13338532", file.creator.modelID);

    [self assertModel:modifier isEquivalentTo:file.lastModifier];
    XCTAssertEqualObjects(@"13338532", file.lastModifier.modelID);

    [self assertModel:owner isEquivalentTo:file.owner];
    XCTAssertEqualObjects(@"13338532", file.owner.modelID);

    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:file.parentFolder];
    XCTAssertEqualObjects(@"0", file.parentFolder.modelID);

    XCTAssertEqualObjects(@"active", file.status);
    XCTAssertEqualObjects(@"f34df557706317b50ee400e072eb731032fe27d3", file.SHA1);
    XCTAssertEqualObjects([NSNumber numberWithInteger:0], file.commentCount);
    NSArray *accessLevels = @[@"collaborators", @"open"];
    XCTAssertEqualObjects(accessLevels, file.allowedSharedLinkAccessLevels);
    XCTAssertNil(file.versionNumber);
    XCTAssertNil(file.extension);
    XCTAssertNil(file.lock);
    XCTAssertEqual(BOXAPIBooleanYES, file.canDownload);
    XCTAssertEqual(BOXAPIBooleanYES, file.canPreview);
    XCTAssertEqual(BOXAPIBooleanYES, file.canUpload);
    XCTAssertEqual(BOXAPIBooleanYES, file.canComment);
    XCTAssertEqual(BOXAPIBooleanYES, file.canRename);
    XCTAssertEqual(BOXAPIBooleanYES, file.canDelete);
    XCTAssertEqual(BOXAPIBooleanYES, file.canShare);
    XCTAssertEqual(BOXAPIBooleanYES, file.canSetShareAccess);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.isPackage);
    
    NSArray *collectionsJSON = dictionary[BOXAPIObjectKeyCollections];
    NSMutableArray *expectedCollections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];
    for (NSDictionary *dict in collectionsJSON) {
        [expectedCollections addObject:[[BOXCollection alloc] initWithJSON:dict]];
    }
    
    XCTAssertEqual(file.collections.count, expectedCollections.count);
    
    for (NSUInteger i = 0; i < file.collections.count ; i++) {
        [self assertModel:file.collections[i] isEquivalentTo:expectedCollections[i]];
    }
    
    XCTAssertTrue(file.isFile);
    XCTAssertFalse(file.isFolder);
    XCTAssertFalse(file.isBookmark);
    XCTAssertEqual(file.metadata.count, 0);
    
    NSArray *allowedInviteeRoles = @[@"editor", @"viewer"];
    XCTAssertEqualObjects(allowedInviteeRoles, file.allowedInviteeRoles);
    XCTAssertEqualObjects(file.defaultInviteeRole, @"editor");
}

- (void)test_that_file_with_all_fields_with_representations_is_parsed_correctly_from_json
{
    // TODO: We need to revisit file_all_fields to make sure it reflects the latest server API doc.
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_all_fields_representations"];
    BOXFile *file = [[BOXFile alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"123", file.modelID);
    XCTAssertEqualObjects(@"Halloweenie-3.jpg", file.name);
    XCTAssertEqualObjects(@"0", file.etag);
    XCTAssertNil(file.sequenceID);
    XCTAssertEqualObjects(@"", file.itemDescription);
    
    NSNumber *fileSize = [NSNumber numberWithInteger:622592];
    XCTAssertEqualObjects(fileSize, file.size);
    
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:22-07:00"], file.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:23-07:00"], file.modifiedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:43-07:00"], file.contentCreatedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:44-07:00"], file.contentModifiedDate);
    
    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(1, file.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *fileFolder = file.pathFolders[i];
        [self assertModel:folder isEquivalentTo:fileFolder];
    }
    
    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];
    
    [self assertModel:creator isEquivalentTo:file.creator];
    XCTAssertEqualObjects(@"13338532", file.creator.modelID);
    
    [self assertModel:modifier isEquivalentTo:file.lastModifier];
    XCTAssertEqualObjects(@"13338532", file.lastModifier.modelID);
    
    [self assertModel:owner isEquivalentTo:file.owner];
    XCTAssertEqualObjects(@"13338532", file.owner.modelID);
    
    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:file.parentFolder];
    XCTAssertEqualObjects(@"0", file.parentFolder.modelID);
    
    XCTAssertEqualObjects(@"active", file.status);
    XCTAssertEqualObjects(@"f34df557706317b50ee400e072eb731032fe27d3", file.SHA1);
    XCTAssertEqualObjects([NSNumber numberWithInteger:0], file.commentCount);
    NSArray *accessLevels = @[@"collaborators", @"open"];
    XCTAssertEqualObjects(accessLevels, file.allowedSharedLinkAccessLevels);
    XCTAssertNil(file.versionNumber);
    XCTAssertNil(file.extension);
    XCTAssertNil(file.lock);
    XCTAssertEqual(BOXAPIBooleanYES, file.canDownload);
    XCTAssertEqual(BOXAPIBooleanYES, file.canPreview);
    XCTAssertEqual(BOXAPIBooleanYES, file.canUpload);
    XCTAssertEqual(BOXAPIBooleanYES, file.canComment);
    XCTAssertEqual(BOXAPIBooleanYES, file.canRename);
    XCTAssertEqual(BOXAPIBooleanYES, file.canDelete);
    XCTAssertEqual(BOXAPIBooleanYES, file.canShare);
    XCTAssertEqual(BOXAPIBooleanYES, file.canSetShareAccess);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.isPackage);
    
    NSArray *collectionsJSON = dictionary[BOXAPIObjectKeyCollections];
    NSMutableArray *expectedCollections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];
    for (NSDictionary *dict in collectionsJSON) {
        [expectedCollections addObject:[[BOXCollection alloc] initWithJSON:dict]];
    }
    
    XCTAssertEqual(file.collections.count, expectedCollections.count);
    
    for (NSUInteger i = 0; i < file.collections.count ; i++) {
        [self assertModel:file.collections[i] isEquivalentTo:expectedCollections[i]];
    }
    
    NSDictionary *representationsDictionary = dictionary[BOXAPIObjectKeyRepresentations];
    NSArray *representationsJSON = [representationsDictionary objectForKey:@"entries"];
    NSMutableArray *expectedRepresentations = [NSMutableArray arrayWithCapacity:representationsJSON.count];
    for (NSDictionary *dict in representationsJSON) {
        [expectedRepresentations addObject:[[BOXRepresentation alloc] initWithJSON:dict]];
    }
    
    XCTAssertEqual(file.representations.count, expectedRepresentations.count);
    for (NSUInteger i = 0; i < file.representations.count; i++) {
        BOXRepresentation *representation = file.representations[i];
        BOXRepresentation *expectedRepresentation = expectedRepresentations[i];
        XCTAssertEqualObjects(representation.status, expectedRepresentation.status);
        XCTAssertEqualObjects(representation.type, expectedRepresentation.type);
        XCTAssertEqualObjects(representation.contentURL, expectedRepresentation.contentURL);
        XCTAssertEqualObjects(representation.infoURL, expectedRepresentation.infoURL);
        XCTAssertEqualObjects(representation.dimensions, expectedRepresentation.dimensions);
        XCTAssertEqualObjects(representation.details, expectedRepresentation.details);
    }
    
    XCTAssertTrue(file.isFile);
    XCTAssertFalse(file.isFolder);
    XCTAssertFalse(file.isBookmark);
}

- (void)test_that_file_with_all_fields_with_enterprise_metadata_is_parsed_correctly_from_json
{
    // TODO: We need to revisit file_all_fields to make sure it reflects the latest server API doc.
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_all_fields_enterprise_metadata"];
    BOXFile *file = [[BOXFile alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"123", file.modelID);
    XCTAssertEqualObjects(@"Halloweenie-3.jpg", file.name);
    XCTAssertEqualObjects(@"0", file.etag);
    XCTAssertNil(file.sequenceID);
    XCTAssertEqualObjects(@"", file.itemDescription);

    NSNumber *fileSize = [NSNumber numberWithInteger:622592];
    XCTAssertEqualObjects(fileSize, file.size);

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:22-07:00"], file.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-22T17:02:23-07:00"], file.modifiedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:43-07:00"], file.contentCreatedDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-09-11T18:40:44-07:00"], file.contentModifiedDate);

    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(1, file.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *fileFolder = file.pathFolders[i];
        [self assertModel:folder isEquivalentTo:fileFolder];
    }

    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];

    [self assertModel:creator isEquivalentTo:file.creator];
    XCTAssertEqualObjects(@"13338532", file.creator.modelID);

    [self assertModel:modifier isEquivalentTo:file.lastModifier];
    XCTAssertEqualObjects(@"13338532", file.lastModifier.modelID);

    [self assertModel:owner isEquivalentTo:file.owner];
    XCTAssertEqualObjects(@"13338532", file.owner.modelID);

    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:file.parentFolder];
    XCTAssertEqualObjects(@"0", file.parentFolder.modelID);

    XCTAssertEqualObjects(@"active", file.status);
    XCTAssertEqualObjects(@"f34df557706317b50ee400e072eb731032fe27d3", file.SHA1);
    XCTAssertEqualObjects([NSNumber numberWithInteger:0], file.commentCount);
    NSArray *accessLevels = @[@"collaborators", @"open"];
    XCTAssertEqualObjects(accessLevels, file.allowedSharedLinkAccessLevels);
    XCTAssertNil(file.versionNumber);
    XCTAssertNil(file.extension);
    XCTAssertNil(file.lock);
    XCTAssertEqual(BOXAPIBooleanYES, file.canDownload);
    XCTAssertEqual(BOXAPIBooleanYES, file.canPreview);
    XCTAssertEqual(BOXAPIBooleanYES, file.canUpload);
    XCTAssertEqual(BOXAPIBooleanYES, file.canComment);
    XCTAssertEqual(BOXAPIBooleanYES, file.canRename);
    XCTAssertEqual(BOXAPIBooleanYES, file.canDelete);
    XCTAssertEqual(BOXAPIBooleanYES, file.canShare);
    XCTAssertEqual(BOXAPIBooleanYES, file.canSetShareAccess);
    XCTAssertEqual(BOXAPIBooleanUnknown, file.isPackage);

    NSArray *collectionsJSON = dictionary[BOXAPIObjectKeyCollections];
    NSMutableArray *expectedCollections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];
    for (NSDictionary *dict in collectionsJSON) {
        [expectedCollections addObject:[[BOXCollection alloc] initWithJSON:dict]];
    }

    XCTAssertEqual(file.collections.count, expectedCollections.count);

    for (NSUInteger i = 0; i < file.collections.count ; i++) {
        [self assertModel:file.collections[i] isEquivalentTo:expectedCollections[i]];
    }

    XCTAssertTrue(file.isFile);
    XCTAssertFalse(file.isFolder);
    XCTAssertFalse(file.isBookmark);

    XCTAssertEqual(file.metadata.count, 1);
    BOXMetadata *metadata = file.metadata[0];
    XCTAssertEqualObjects(@"yes", metadata.info[@"contentApproved"]);
}
@end

