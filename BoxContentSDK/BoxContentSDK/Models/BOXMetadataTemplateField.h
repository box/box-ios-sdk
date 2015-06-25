//
//  BOXMetadataTemplateField.h
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

/**
 * Represents fields for @see BOXMetadataTemplates.
 */
@interface BOXMetadataTemplateField : BOXModel

/**
 * The name of the field.
 */
@property (nonatomic, readwrite, strong) NSString *displayName;

/**
 * An array of all options available to the field. 
 *
 * **NOTE** All values in options should be non-user defined objects.
 *          Ex. NSString, NSNumber, NSDictioanry, NSArray, etc.
 */
@property (nonatomic, readwrite, strong) NSArray *options;

@end
