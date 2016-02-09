//
//  BOXBookmarkTests
//  BoxContentSDK
//

#import "BOXModelTestCase.h"
#import "BOXBookmark.h"
#import "BOXFolder.h"
#import "BOXUser.h"

@interface BOXBookmarkTests : BOXModelTestCase
@end

@implementation BOXBookmarkTests

- (void)test_that_mini_bookmark_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"bookmark_mini_fields"];
    BOXBookmarkMini *bookmark = [[BOXBookmarkMini alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"6006481", bookmark.modelID);
    XCTAssertEqualObjects(@"Box Developer Site", bookmark.name);
    XCTAssertEqualObjects(@"0", bookmark.etag);
    XCTAssertEqualObjects(@"0", bookmark.sequenceID);
    XCTAssertFalse(bookmark.isFile);
    XCTAssertFalse(bookmark.isFolder);
    XCTAssertTrue(bookmark.isBookmark);
}

- (void)test_that_bookmark_with_default_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"bookmark_default_fields"];
    BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"6006481", bookmark.modelID);
    XCTAssertEqualObjects(@"Box Developer Site", bookmark.name);
    XCTAssertEqualObjects(@"0", bookmark.etag);
    XCTAssertEqualObjects(@"0", bookmark.sequenceID);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://developers.box.com/"], bookmark.URL);
    XCTAssertEqualObjects(@"", bookmark.itemDescription);

    // No size

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:19:36-08:00"], bookmark.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:19:36-08:00"], bookmark.modifiedDate);

    // No content creation/modification dates

    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(2, bookmark.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *bookmarkFolder = bookmark.pathFolders[i];
        [self assertModel:folder isEquivalentTo:bookmarkFolder];

        if (i == 0) {
            XCTAssertEqualObjects(@"0", folder.modelID);
        } else {
            XCTAssertEqualObjects(@"2759406491", folder.modelID);
        }
    }

    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];

    [self assertModel:creator isEquivalentTo:bookmark.creator];
    XCTAssertEqualObjects(@"15220407", bookmark.creator.modelID);

    [self assertModel:modifier isEquivalentTo:bookmark.lastModifier];
    XCTAssertEqualObjects(@"15220407", bookmark.lastModifier.modelID);

    [self assertModel:owner isEquivalentTo:bookmark.owner];
    XCTAssertEqualObjects(@"15220407", bookmark.owner.modelID);

    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:bookmark.parentFolder];
    XCTAssertEqualObjects(@"2759406491", bookmark.parentFolder.modelID);

    XCTAssertEqualObjects(@"active", bookmark.status);
    XCTAssertNil(bookmark.allowedSharedLinkAccessLevels);

    XCTAssertEqual(BOXAPIBooleanUnknown, bookmark.canComment);
    XCTAssertEqual(BOXAPIBooleanUnknown, bookmark.canRename);
    XCTAssertEqual(BOXAPIBooleanUnknown, bookmark.canDelete);
    XCTAssertEqual(BOXAPIBooleanUnknown, bookmark.canShare);
    XCTAssertEqual(BOXAPIBooleanUnknown, bookmark.canSetShareAccess);
    
    XCTAssertFalse(bookmark.isFile);
    XCTAssertFalse(bookmark.isFolder);
    XCTAssertTrue(bookmark.isBookmark);
}

- (void)test_that_bookmark_with_all_fields_is_parsed_correctly_from_json
{
    // TODO: We need to revisit bookmark_all_fields to make sure it reflects the latest server API doc.
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"bookmark_all_fields"];
    BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"6006481", bookmark.modelID);
    XCTAssertEqualObjects(@"Box Developer Site", bookmark.name);
    XCTAssertEqualObjects(@"0", bookmark.etag);
    XCTAssertEqualObjects(@"0", bookmark.sequenceID);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://developers.box.com/"], bookmark.URL);
    XCTAssertEqualObjects(@"", bookmark.itemDescription);

    // No size

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:19:36-08:00"], bookmark.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-01T15:19:36-08:00"], bookmark.modifiedDate);

    // No content creation/modification dates

    NSDictionary *pathDictionary = dictionary[BOXAPIObjectKeyPathCollection];
    NSArray *pathArray = pathDictionary[@"entries"];
    XCTAssertEqual(2, bookmark.pathFolders.count);
    for (int i = 0; i < pathArray.count; i ++) {
        BOXFolderMini *folder = [[BOXFolderMini alloc] initWithJSON:pathArray[i]];
        BOXFolderMini *bookmarkFolder = bookmark.pathFolders[i];
        [self assertModel:folder isEquivalentTo:bookmarkFolder];

        if (i == 0) {
            XCTAssertEqualObjects(@"0", folder.modelID);
        } else {
            XCTAssertEqualObjects(@"2759406491", folder.modelID);
        }
    }

    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXUserMini *modifier = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyModifiedBy]];
    BOXUserMini *owner = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyOwnedBy]];

    [self assertModel:creator isEquivalentTo:bookmark.creator];
    XCTAssertEqualObjects(@"15220407", bookmark.creator.modelID);
    
    [self assertModel:modifier isEquivalentTo:bookmark.lastModifier];
    XCTAssertEqualObjects(@"15220407", bookmark.lastModifier.modelID);
    
    [self assertModel:owner isEquivalentTo:bookmark.owner];
    XCTAssertEqualObjects(@"15220407", bookmark.owner.modelID);
    
    BOXFolderMini *parentFolder = [[BOXFolderMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyParent]];
    [self assertModel:parentFolder isEquivalentTo:bookmark.parentFolder];
    XCTAssertEqualObjects(@"2759406491", bookmark.parentFolder.modelID);

    XCTAssertEqualObjects(@"active", bookmark.status);
    XCTAssertEqualObjects([NSNumber numberWithInteger:2], bookmark.commentCount);
    NSArray *accessLevels = @[@"collaborators", @"open"];
    XCTAssertEqualObjects(accessLevels, bookmark.allowedSharedLinkAccessLevels);
    XCTAssertEqual(BOXAPIBooleanYES, bookmark.canComment);
    XCTAssertEqual(BOXAPIBooleanYES, bookmark.canRename);
    XCTAssertEqual(BOXAPIBooleanYES, bookmark.canDelete);
    XCTAssertEqual(BOXAPIBooleanYES, bookmark.canShare);
    XCTAssertEqual(BOXAPIBooleanYES, bookmark.canSetShareAccess);
    
    XCTAssertFalse(bookmark.isFile);
    XCTAssertFalse(bookmark.isFolder);
    XCTAssertTrue(bookmark.isBookmark);
}

@end

