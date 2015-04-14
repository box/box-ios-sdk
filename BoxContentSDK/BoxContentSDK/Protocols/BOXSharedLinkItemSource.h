//
//  BOXSharedLinkItemSource.h
//  BoxContentSDK
//
//  Created on 1/26/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

@protocol BOXSharedLinkItemSource <NSObject>

@required
// The itemID we need to use to retrieve the headers needed to perform this api request
- (NSString *)itemIDForSharedLink;

// The type of the item we need to use to retrieve the headers needed to perform this api request
- (BOXAPIItemType *)itemTypeForSharedLink;


@end
