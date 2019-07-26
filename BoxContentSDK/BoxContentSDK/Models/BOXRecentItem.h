//
//  BOXRecentItem.h
//  Pods
//
//  Created by Andrew Dempsey on 12/19/16.
//
//

#import <BoxContentSDK/BOXContentSDK.h>

/**
 Represents an item recently interacted with by the current user.
 */
@interface BOXRecentItem : BOXModel

/**
 The item that was recently interacted with by the user.
 As of 12/21/16, supported item types are:
 - BOXFile
 - BOXBookmark
 */
@property (nonatomic, readwrite, strong) BOXItem *item;

/**
 The latest type of interaction that the user performed on the item.
 Possible values are: 
 - BOXAPIRecentItemsInteractionTypePreview
 - BOXAPIRecentItemsInteractionTypeComment
 - BOXAPIRecentItemsInteractionTypeModification
 */
@property (nonatomic, readwrite, strong) NSString *interactionType;

/**
 The most recent date the user interacted with the item.
 */
@property (nonatomic, readwrite, strong) NSDate *interactionDate;

/**
 URL for the shared link that was used to access the item by the user.
 nil if not applicable
 */
@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;

@end
