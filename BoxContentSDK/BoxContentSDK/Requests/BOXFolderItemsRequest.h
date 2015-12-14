//
//  BOXFolderItemsRequest.h
//  BoxContentSDK
//
//  Created by Boris Suvorov on 3/31/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderItemsRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

- (instancetype)initWithFolderID:(NSString *)folderID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXItemsBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXItemsBlock)cacheBlock
                       refreshed:(BOXItemsBlock)refreshBlock;

@end
