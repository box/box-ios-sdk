//
//  BOXEnterprise.h
//  BoxContentSDK
//
//  Created by Rico Yao on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

/**
 *  Represents an Enterprise on Box.
 */
@interface BOXEnterpriseMini : BOXModel

/**
 *  Name of the enterprise.
 */
@property (nonatomic, readwrite, strong) NSString *name;

@end

@interface BOXEnterprise : BOXModel

// We don't have anything in the SDK yet that deals with a full enterprise object so not needed yet.

@end
