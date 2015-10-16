//
//  BOXMetadataCreateRequest.h
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

/**
 * BOXMetadataCreateRequest is a concrete implementation of BOXRequest that allows users to
 * use the BOXContentSDK to create metadata associated with a given file.
 *
 * Currently the BOXContentSDK only supports the enterprise scope and templates are
 * determined by an enterprise by enterprise basis.
 *
 * More information can be found at the link below:
 * https://box-content.readme.io/#create-metadata
 */
@interface BOXMetadataCreateRequest : BOXRequest

/**
 * Suppliable ETags for the HTTPRequests header.
 */
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;

/**
 * The scope of the BOXMetadataCreateRequest. Determines which templates are available.
 *
 * Currently only enterprise and global are supported scopes within metadata.
 */
@property (nonatomic, readwrite, strong) NSString *scope;

/**
 * The template name for the given scope of the BOXMetadataCreateRequest.
 *
 * Templates are handled on a enterprise by enterprise basis. To see available metadata
 * templates @see BOXMetadataTemplateRequest.
 */
@property (nonatomic, readwrite, strong) NSString *templateName;

/**
 * The information to populate the initial metadata's template with.
 *
 * **NOTE** Must only contain instances of @see BOXMetadataKeyValue.
 */
@property (nonatomic, readwrite, strong) NSArray *tasks;

/**
 * Returns a BOXMetadataCreateRequest instance that allows users
 * to create metadata information on a given file.
 *
 * **NOTE** Scope is defaulted to @see BOXAPIScopeEnterprise in this initializer.
 * **NOTE** tasks must only contain instances of @see BOXMetadataKeyValue.
 *
 * @param fileID The ID of the desired file.
 * @param template The templateKey of the desired metadata information for the given file.
 * @param tasks The collection of custom metadata key/value pairs to apply with BOXMetadataKeyValue objects.
 *
 * @return A BOXMetadataCreateRequest that allows users to create metadata information on a given file.
 */
- (instancetype)initWithFileID:(NSString *)fileID template:(NSString *)templateName tasks:(NSArray *)tasks;

/**
 * Designated initializer. Returns a BOXMetadataCreateRequest instance that allows users
 * to create metadata information on a given file.
 *
 * **NOTE** tasks must only contain instances of @see BOXMetadataKeyValue.
 *
 * @param fileID The ID of the desired file.
 * @param scope The scope of the templates desired for creating a metadata template instance.
 * @param template The templateKey of the desired metadata information for the given file.
 * @param tasks The collection of custom metadata key/value pairs to apply with BOXMetadataKeyValue objects.
 *
 * @return A BOXMetadataCreateRequest that allows users to create metadata information on a given file.
 */
- (instancetype)initWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName tasks:(NSArray *)tasks;

/**
 * Performs the POST request to create metadata information.
 *
 * @param completionBlock The block of code to be run after the POST request has completed
 *                        regardless of success.
 */
- (void)performRequestWithCompletion:(BOXMetadataBlock)completionBlock;

@end