//
//  BOXFolderItemsRequest.h
//  BoxContentSDK
//
//  Created by Boris Suvorov on 3/31/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>
#import "BOXFolderPaginatedItemsRequest.h"

@interface BOXFolderItemsRequest : BOXFolderPaginatedItemsRequest

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXItemsBlock)completionBlock;

@end
