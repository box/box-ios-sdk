//
//  BOXMetadata.h
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

/**
 * Represents metadata information from a template.
 */
@interface BOXMetadata : BOXModel

/**
 * The file ID that metadata belongs to.
 */
@property (nonatomic, readwrite, strong) NSString *parent;

/**
 * The template that the metadata information belongs to.
 */
@property (nonatomic, readwrite, strong) NSString *templateName;

/**
 * The scope that the metadata's template belongs to.
 */
@property (nonatomic, readwrite, strong) NSString *scope;

/**
 * Custom defined information stored as key/value pairs.
 */
@property (nonatomic, readwrite, strong) NSDictionary *info;

/**
 *  Initialize with a dictionary from Box API response JSON.
 *
 *  @param Dictionary from Box API response JSON.
 *
 *  @return The model object.
 */
- (instancetype)initWithJSON:(NSDictionary *)JSONData;

@end