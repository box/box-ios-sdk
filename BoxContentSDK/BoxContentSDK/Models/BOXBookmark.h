//
//  BOXBookmark.h
//  BoxContentSDK
//
//  Created on 12/4/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXItem.h"

/**
 *  A compact representation of a Bookmark with only a few properties.
 *  Some API requests will return these representations to reduce bandiwdth, especially when many
 *  instances are being returned.
 */
@interface BOXBookmarkMini : BOXItemMini

/**
 *  The URL of the Bookmark.
 */
@property (nonatomic, readwrite, strong) NSURL *URL;

@end

/**
 *  Represents a Bookmark (a.k.a. Weblink) on Box.
 */
@interface BOXBookmark : BOXItem

/**
 *  The URL of the Bookmark.
 */
@property (nonatomic, readwrite, strong) NSURL *URL;

/**
 *  The number of comments that have been made on this item.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSNumber *commentCount;

/**
 *  Indicates permission for the current user to comment on the item.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canComment;

@end
