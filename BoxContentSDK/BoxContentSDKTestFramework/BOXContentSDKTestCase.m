//
//  BoxContentSDKTestCase.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/21/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentSDKTestCase.h"
#import "BOXItem.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXUser.h"
#import "BOXSharedLink.h"
#import "BOXFileLock.h"
#import "BOXComment.h"
#import "BOXCollection.h"
#import "BOXEvent.h"
#import "BOXFileVersion.h"
#import "BOXCollaboration.h"
#import "BOXMetadata.h"

@implementation BOXContentSDKTestCase

- (void)setUp
{
    [super setUp];
    [self wipeAllKeychainEntries];
}

- (void)tearDown
{
    [self wipeAllKeychainEntries];
    [super tearDown];
}

- (void)assertModel:(BOXModel *)modelA isEquivalentTo:(BOXModel *)modelB
{
    if (modelA == nil && modelB == nil)
    {
        return;
    }
    
    XCTAssertEqualObjects([modelA class], [modelB class]);
    XCTAssertEqualObjects(modelA.modelID, modelB.modelID);
    XCTAssertEqualObjects(modelA.type, modelB.type);
    
    if ([modelA isKindOfClass:[BOXItem class]])
    {
        BOXItem *itemA = (BOXItem *)modelA;
        BOXItem *itemB = (BOXItem *)modelB;
        XCTAssertEqualObjects(itemA.name, itemB.name);
        XCTAssertEqualObjects(itemA.sequenceID, itemB.sequenceID);
        XCTAssertEqualObjects(itemA.etag, itemB.etag);
        [self assertItemCollection:itemA.pathFolders isEquivalentTo:itemB.pathFolders];
        XCTAssertEqualObjects(itemA.createdDate, itemB.createdDate);
        XCTAssertEqualObjects(itemA.modifiedDate, itemB.modifiedDate);
        XCTAssertEqualObjects(itemA.itemDescription, itemB.itemDescription);
        XCTAssertEqualObjects(itemA.size, itemB.size);
        XCTAssertEqualObjects(itemA.trashedDate, itemB.trashedDate);
        XCTAssertEqualObjects(itemA.purgedDate, itemB.purgedDate);
        XCTAssertEqualObjects(itemA.contentCreatedDate, itemB.contentCreatedDate);
        XCTAssertEqualObjects(itemA.contentModifiedDate, itemB.contentModifiedDate);
        [self assertModel:itemA.creator isEquivalentTo:itemB.creator];
        [self assertModel:itemA.lastModifier isEquivalentTo:itemB.lastModifier];
        [self assertModel:itemA.owner isEquivalentTo:itemB.owner];
        [self assertSharedLink:itemA.sharedLink isEquivalentTo:itemB.sharedLink];
        [self assertModel:itemA.parentFolder isEquivalentTo:itemB.parentFolder];
        XCTAssertEqualObjects(itemA.status, itemB.status);
        
        if ([modelA isKindOfClass:[BOXFile class]])
        {
            BOXFile *fileA = (BOXFile *)modelA;
            BOXFile *fileB = (BOXFile *)modelB;
            XCTAssertEqualObjects(fileA.SHA1, fileB.SHA1);
            XCTAssertEqualObjects(fileA.versionNumber, fileB.versionNumber);
            XCTAssertEqualObjects(fileA.commentCount, fileB.commentCount);
            XCTAssertEqualObjects(fileA.extension, fileB.extension);
            XCTAssertEqual(fileA.canDownload, fileB.canDownload);
            XCTAssertEqual(fileA.canPreview, fileB.canPreview);
            XCTAssertEqual(fileA.canUpload, fileB.canUpload);
            XCTAssertEqual(fileA.canComment, fileB.canComment);
            XCTAssertEqual(fileA.canRename, fileB.canRename);
            XCTAssertEqual(fileA.canDelete, fileB.canDelete);
            XCTAssertEqual(fileA.canShare, fileB.canShare);
            XCTAssertEqual(fileA.canSetShareAccess, fileB.canSetShareAccess);
            XCTAssertEqual(fileA.isPackage, fileB.isPackage);
            [self assertModel:fileA.lock isEquivalentTo:fileB.lock];
        }
        else if ([modelA isKindOfClass:[BOXFolder class]])
        {
            BOXFolder *folderA = (BOXFolder *)modelA;
            BOXFolder *folderB = (BOXFolder *)modelB;
            XCTAssertEqualObjects(folderA.folderUploadEmailAccess, folderB.folderUploadEmailAccess);
            XCTAssertEqualObjects(folderA.folderUploadEmailAddress, folderB.folderUploadEmailAddress);
            XCTAssertEqualObjects(folderA.syncState, folderB.syncState);
            XCTAssertEqual(folderA.hasCollaborations, folderB.hasCollaborations);
            XCTAssertEqual(folderA.canDownload, folderB.canDownload);
            XCTAssertEqual(folderA.canUpload, folderB.canUpload);
            XCTAssertEqual(folderA.canRename, folderB.canRename);
            XCTAssertEqual(folderA.canDelete, folderB.canDelete);
            XCTAssertEqual(folderA.canShare, folderB.canShare);
            XCTAssertEqual(folderA.canSetShareAccess, folderB.canSetShareAccess);
            XCTAssertEqual(folderA.canInviteCollaborator, folderB.canInviteCollaborator);
            XCTAssertEqual(folderA.canNonOwnersInvite, folderB.canNonOwnersInvite);
        }
        else if ([modelA isKindOfClass:[BOXBookmark class]]) {
            BOXBookmark *webLinkA = (BOXBookmark *)modelA;
            BOXBookmark *webLinkB = (BOXBookmark *)modelB;
            XCTAssertEqualObjects(webLinkA.URL, webLinkB.URL);
            XCTAssertEqual(webLinkA.canComment, webLinkB.canComment);
            XCTAssertEqual(webLinkA.canRename, webLinkB.canRename);
            XCTAssertEqual(webLinkA.canDelete, webLinkB.canDelete);
            XCTAssertEqual(webLinkA.canShare, webLinkB.canShare);
            XCTAssertEqual(webLinkA.canSetShareAccess, webLinkB.canSetShareAccess);
            XCTAssertEqualObjects(webLinkA.commentCount, webLinkA.commentCount);
        }
        else
        {
            XCTFail(@"You must implement an equivalency test for class %@", NSStringFromClass([modelA class]));
        }
    }
    else if ([modelA isKindOfClass:[BOXItemMini class]])
    {
        BOXItemMini *itemA = (BOXItemMini *)modelA;
        BOXItemMini *itemB = (BOXItemMini *)modelB;
        XCTAssertEqualObjects(itemA.type, itemB.type);
        XCTAssertEqualObjects(itemA.name, itemB.name);
        XCTAssertEqualObjects(itemA.sequenceID, itemB.sequenceID);
        XCTAssertEqualObjects(itemA.etag, itemB.etag);
        
        if ([modelA isKindOfClass:[BOXFileMini class]])
        {
            // Nothing more to check
        }
        else if ([modelA isKindOfClass:[BOXFolderMini class]])
        {
            // Nothing more to check
        }
        else if ([modelA isKindOfClass:[BOXBookmarkMini class]]) {
            BOXBookmarkMini *webLinkA = (BOXBookmarkMini *)modelA;
            BOXBookmarkMini *webLinkB = (BOXBookmarkMini *)modelB;
            XCTAssertEqualObjects(webLinkA.URL, webLinkB.URL);
        }
    }
    else if ([modelA isKindOfClass:[BOXUser class]])
    {
        BOXUser *userA = (BOXUser *)modelA;
        BOXUser *userB = (BOXUser *)modelB;
        XCTAssertEqualObjects(userA.login, userB.login);
        XCTAssertEqualObjects(userA.name, userB.name);
        XCTAssertEqualObjects(userA.createdDate, userB.createdDate);
        XCTAssertEqualObjects(userA.modifiedDate, userB.modifiedDate);
        XCTAssertEqualObjects(userA.language, userB.language);
        XCTAssertEqualObjects(userA.timeZone, userB.timeZone);
        XCTAssertEqualObjects(userA.spaceAmount, userB.spaceAmount);
        XCTAssertEqualObjects(userA.spaceUsed, userB.spaceUsed);
        XCTAssertEqualObjects(userA.maxUploadSize, userB.maxUploadSize);
        XCTAssertEqualObjects(userA.status, userB.status);
        XCTAssertEqualObjects(userA.jobTitle, userB.jobTitle);
        XCTAssertEqualObjects(userA.phone, userB.phone);
        XCTAssertEqualObjects(userA.address, userB.address);
        XCTAssertEqualObjects(userA.role, userB.role);
        XCTAssertEqualObjects(userA.trackingCodes, userB.trackingCodes);
        XCTAssertEqual(userA.canSeeManagedUsers, userB.canSeeManagedUsers);
        XCTAssertEqual(userA.isSyncEnabled, userB.isSyncEnabled);
        XCTAssertEqual(userA.isExternalCollabRestricted, userB.isExternalCollabRestricted);
        XCTAssertEqual(userA.isExemptFromDeviceLimits, userB.isExemptFromDeviceLimits);
        XCTAssertEqual(userA.isExemptFromLoginVerification, userB.isExemptFromLoginVerification);
        [self assertModel:userA.enterprise isEquivalentTo:userB.enterprise];
    }
    else if ([modelA isKindOfClass:[BOXUserMini class]])
    {
        BOXUserMini *userA = (BOXUserMini *)modelA;
        BOXUserMini *userB = (BOXUserMini *)modelB;
        XCTAssertEqualObjects(userA.login, userB.login);
        XCTAssertEqualObjects(userA.name, userB.name);
    }
    else if ([modelA isKindOfClass:[BOXEnterpriseMini class]])
    {
        BOXEnterpriseMini *enterpriseA = (BOXEnterpriseMini *)modelA;
        BOXEnterpriseMini *enterpriseB = (BOXEnterpriseMini *)modelB;
        XCTAssertEqualObjects(enterpriseA.name, enterpriseB.name);
    }
    else if ([modelA isKindOfClass:[BOXFileVersion class]])
    {
        BOXFileVersion *fileVersionA = (BOXFileVersion *)modelA;
        BOXFileVersion *fileVersionB = (BOXFileVersion *)modelB;
        XCTAssertEqualObjects(fileVersionA.name, fileVersionB.name);
        XCTAssertEqualObjects(fileVersionA.sha1, fileVersionB.sha1);
        XCTAssertEqualObjects(fileVersionA.size, fileVersionB.size);
        XCTAssertEqualObjects(fileVersionA.createdDate, fileVersionB.createdDate);
        XCTAssertEqualObjects(fileVersionA.modifiedDate, fileVersionB.modifiedDate);
        [self assertModel:fileVersionA.lastModifier isEquivalentTo:fileVersionA.lastModifier];
    }
    else if ([modelA isKindOfClass:[BOXFileLock class]])
    {
        BOXFileLock *lockA = (BOXFileLock *)modelA;
        BOXFileLock *lockB = (BOXFileLock *)modelB;
        XCTAssertEqualObjects(lockA.creator, lockB.creator);
        XCTAssertEqualObjects(lockA.createdDate, lockB.createdDate);
        XCTAssertEqualObjects(lockA.expirationDate, lockB.expirationDate);
        XCTAssertEqual(lockA.isDownloadPrevented, lockB.isDownloadPrevented);
    }
    else if ([modelA isKindOfClass:[BOXComment class]]) {
        BOXComment *commentA = (BOXComment *)modelA;
        BOXComment *commentB = (BOXComment *)modelB;
        XCTAssertEqualObjects(commentA.message, commentA.message);
        XCTAssertEqualObjects(commentA.taggedMessage, commentA.taggedMessage);
        XCTAssertEqualObjects(commentA.createdDate, commentB.createdDate);
        XCTAssertEqualObjects(commentA.modifiedDate, commentB.modifiedDate);        
        XCTAssertEqual(commentA.isReplyComment, commentB.isReplyComment);
        [self assertModel:commentA.item isEquivalentTo:commentB.item];
        [self assertModel:commentA.creator isEquivalentTo:commentB.creator];
    }
    else if ([modelA isKindOfClass:[BOXCollection class]]) {
        BOXCollection *collectionA = (BOXCollection *)modelA;
        BOXCollection *collectionB = (BOXCollection *)modelB;
        XCTAssertEqualObjects(collectionA.modelID, collectionB.modelID);
        XCTAssertEqualObjects(collectionA.type, collectionB.type);
        XCTAssertEqualObjects(collectionA.name, collectionB.name);
        XCTAssertEqualObjects(collectionA.collectionType, collectionB.collectionType);
    } 
    else if ([modelA isKindOfClass:[BOXEvent class]]) {
        BOXEvent *eventA = (BOXEvent *)modelA;
        BOXEvent *eventB = (BOXEvent *)modelB;
        XCTAssertEqualObjects(eventA.modelID, eventB.modelID);
        XCTAssertEqualObjects(eventA.eventType, eventB.eventType);
        XCTAssertEqualObjects(eventA.createdDate, eventB.createdDate);
        XCTAssertEqualObjects(eventA.sessionID, eventB.sessionID);
        [self assertModel:eventA.creator isEquivalentTo:eventB.creator];
        [self assertModel:eventA.source isEquivalentTo:eventB.source];
    }
    else if ([modelA isKindOfClass:[BOXCollaboration class]]) {
        BOXCollaboration *collaborationA = (BOXCollaboration *)modelA;
        BOXCollaboration *collaborationB = (BOXCollaboration *)modelB;
        XCTAssertEqualObjects(collaborationA.modelID, collaborationB.modelID);
        XCTAssertEqualObjects(collaborationA.type, collaborationB.type);
        XCTAssertEqualObjects(collaborationA.createdDate, collaborationB.createdDate);
        XCTAssertEqualObjects(collaborationA.modificationDate, collaborationB.modificationDate);
        XCTAssertEqualObjects(collaborationA.expirationDate, collaborationB.expirationDate);
        XCTAssertEqualObjects(collaborationA.status, collaborationB.status);
        XCTAssertEqualObjects(collaborationA.role, collaborationB.role);
        XCTAssertEqualObjects(collaborationA.acknowledgedDate, collaborationB.acknowledgedDate);
        [self assertModel:collaborationA.creator isEquivalentTo:collaborationB.creator];
        [self assertModel:collaborationA.item isEquivalentTo:collaborationB.item];
        [self assertModel:collaborationA.accessibleBy isEquivalentTo:collaborationB.accessibleBy];
    }
    else if ([modelA isKindOfClass:[BOXMetadata class]]) {
        BOXMetadata *metadataA = (BOXMetadata *)modelA;
        BOXMetadata *metadataB = (BOXMetadata *)modelB;
        XCTAssertEqualObjects(metadataA.modelID, metadataB.modelID);
        XCTAssertEqualObjects(metadataA.type, metadataB.type);
        XCTAssertEqualObjects(metadataA.parent, metadataB.parent);
        XCTAssertEqualObjects(metadataA.templateName, metadataB.templateName);
        XCTAssertEqualObjects(metadataA.scope, metadataB.scope);
        XCTAssertEqualObjects(metadataA.info, metadataB.info);
    }
    else
    {
        XCTFail(@"You must implement an equivalency test for class %@", NSStringFromClass([modelA class]));
    }
    
}

- (void)assertItemCollection:(NSArray *)itemCollectionA isEquivalentTo:(NSArray *)itemCollectionB
{
    XCTAssertEqual(itemCollectionA.count, itemCollectionB.count);
    for (int i = 0; i < itemCollectionA.count; i++)
    {
        XCTAssertTrue([[itemCollectionA objectAtIndex:i] isKindOfClass:[BOXItem class]] || [[itemCollectionA objectAtIndex:i] isKindOfClass:[BOXItemMini class]]);
        XCTAssertEqualObjects([[itemCollectionA objectAtIndex:i] class], [[itemCollectionB objectAtIndex:i] class]);
        [self assertModel:[itemCollectionA objectAtIndex:i] isEquivalentTo:[itemCollectionB objectAtIndex:i]];
    }
}

- (void)assertSharedLink:(BOXSharedLink *)sharedLinkA isEquivalentTo:(BOXSharedLink *)sharedLinkB
{
    XCTAssertEqualObjects(sharedLinkA.url, sharedLinkB.url);
    XCTAssertEqualObjects(sharedLinkA.downloadURL, sharedLinkB.downloadURL);
    XCTAssertEqualObjects(sharedLinkA.vanityURL, sharedLinkB.vanityURL);
    XCTAssertEqual(sharedLinkA.isPasswordEnabled, sharedLinkB.isPasswordEnabled);
    XCTAssertEqualObjects(sharedLinkA.accessLevel, sharedLinkB.accessLevel);
    XCTAssertEqualObjects(sharedLinkA.effectiveAccessLevel, sharedLinkB.effectiveAccessLevel);
    XCTAssertEqual(sharedLinkA.canDownload, sharedLinkB.canDownload);
    XCTAssertEqual(sharedLinkA.canPreview, sharedLinkB.canPreview);
    XCTAssertEqualObjects(sharedLinkA.expirationDate, sharedLinkB.expirationDate);
    XCTAssertEqualObjects(sharedLinkA.downloadCount, sharedLinkB.downloadCount);
    XCTAssertEqualObjects(sharedLinkA.previewCount, sharedLinkB.previewCount);
}

- (void)wipeAllKeychainEntries
{
    NSArray *secClases = @[(__bridge id)kSecClassGenericPassword,
                           (__bridge id)kSecClassInternetPassword,
                           (__bridge id)kSecClassCertificate,
                           (__bridge id)kSecClassKey,
                           (__bridge id)kSecClassIdentity];
    
    for (id secClass in secClases) {
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:secClass, (__bridge id)kSecClass, nil];
        SecItemDelete((__bridge CFDictionaryRef)query);
    }
}

@end
