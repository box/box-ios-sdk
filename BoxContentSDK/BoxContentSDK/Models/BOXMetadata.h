//
//  BOXMetadata.h
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXModel.h"

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
 * The current version of the metadata.
 */
@property (nonatomic, readwrite, strong) NSNumber *version;


/**
 * The current type version of the metadata.
 */
@property (nonatomic, readwrite, strong) NSNumber *typeVersion;


/**
 * Custom defined information stored as key/value pairs.
 */
@property (nonatomic, readwrite, strong) NSDictionary *info;

/**
 *  Initialize with a dictionary from Box API response JSON.
 *
 *  @param  JSONData from Box API response JSON.
 *
 *  @return The model object.
 */
- (instancetype)initWithJSON:(NSDictionary *)JSONData;

@end
