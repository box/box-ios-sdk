//
//  BOXMetadataTemplate.h
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

/**
 * Represents metadata template information. Aka, The schema for a template.
 */
@interface BOXMetadataTemplate : BOXModel

/**
 * The scope the template belongs to.
 */
@property (nonatomic, readwrite, strong) NSString *scope;

/**
 * The name of the template.
 */
@property (nonatomic, readwrite, strong) NSString *displayName;

/**
 * The custom fields available in the template. Stored as key/value pairs
 * such that the values can either be a single option or many options in a list.
 *
 * **NOTE** All fields will be of type BOXMetadataTemplateField.
 */
@property (nonatomic, readwrite, strong) NSArray *fields;

@end
