//
//  BOXMetadataTemplateRequest.h
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BoxContentSDK/BOXContentSDK.h>

/**
 * BOXMetadataTemplateRequest is a concrete implementation of BOXRequest that allows users to
 * use the BOXContentSDK to retrieve metadata templates available for a given file.
 *
 * Currently the BOXContentSDK only supports the enterprise scope and templates are
 * determined by an enterprise by enterprise basis.
 *
 * More information can be found at the link below:
 * https://box-content.readme.io/#get-enterprise-templates
 * https://box-content.readme.io/#get-metadata-schema
 */
@interface BOXMetadataTemplateRequest : BOXRequest

/**
 * Suppliable ETags for the HTTPRequests header.
 */
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;

/**
 * The scope of the BOXMetadataTemplateRequest. Determines which templates are available.
 *
 * Currently only enterprise and global are supported scopes within metadata.
 */
@property (nonatomic, readwrite, strong) NSString *scope;

/**
 * The template name for the given scope of the BOXMetadataTemplateRequest.
 *
 * Setting the template property will automatically cause BOXMetadataTemplateRequest to
 * return a single template schema instead of all template schemas available in the given
 * scope.
 *
 * Templates are handled on a enterprise by enterprise basis.
 */
@property (nonatomic, readwrite, strong) NSString *templateName;

/**
 * Designated initializer. Returns a BOXMetadataTemplateRequest that allows users
 * to retrieve the schema to a specific metadata template for a given scope.
 *
 * @param scope The scope to look for templates.
 * @param template The template for the desired schema.
 *
 * @return A BOXMetadataTemplateRequest that allows users to retrieve the schema to
 *         retrieve the schema to a specific metadata template for a given scope.
 */
- (instancetype)initWithScope:(NSString *)scope template:(NSString *)templateName;

/**
 * Designated initializer. Returns a BOXMetadataTemplateRequest that allows users
 * to retrieve all template schemas available in a given scope.
 *
 * @param scope The scope to look for templates.
 *
 * @return A BOXMetadataTemplateRequest that allows users to retrieve all template 
 *         schemas available in a given scope.
 */
- (instancetype)initWithScope:(NSString *)scope;

/**
 * Designated initializer. Returns a BOXMetadataTemplateRequest that allows users
 * to retrieve all template schemas in the enterprise scope.
 *
 * @return A BOXMetadataTemplateRequest that allows users to retrieve all template 
 *         schemas in the enterprise scope.
 */
- (instancetype)init;

/**
 * Performs the GET request to retrieve metadata template schemas.
 * Perform API request and any cache update only if completionBlock is not nil
 *
 * @param completionBlock The block of code to be run after the GET request has completed
 *                        regardless of success.
 */
- (void)performRequestWithCompletion:(BOXMetadataTemplatesBlock)completionBlock;

@end
