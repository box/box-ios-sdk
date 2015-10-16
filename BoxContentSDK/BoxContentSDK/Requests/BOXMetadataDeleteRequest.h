//
//  BOXMetadataDeleteRequest.h
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BOXContentSDK.h>

/**
 * BOXMetadataDeleteRequest is a concrete implementation of BOXRequest that allows users to
 * use the BOXContentSDK to delete metadata associated with a given file.
 *
 * Currently the BOXContentSDK only supports the enterprise scope and templates are
 * determined by an enterprise by enterprise basis.
 *
 * More information can be found at the link below:
 * https://box-content.readme.io/#delete-metadata
 */
@interface BOXMetadataDeleteRequest : BOXRequest

/**
 * Suppliable ETags for the HTTPRequests header.
 */
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;

/**
 * The scope of the BOXMetadataDeleteRequest. Determines which templates are available.
 *
 * Currently only enterprise and global are supported scopes within metadata.
 */
@property (nonatomic, readwrite, strong) NSString *scope;

/**
 * The template name for the given scope of the BOXMetadataDeleteRequest.
 *
 * Templates are handled on a enterprise by enterprise basis. To see available metadata
 * templates @see BOXMetadataTemplateRequest.
 */
@property (nonatomic, readwrite, strong) NSString *templateName;

/**
 * Returns a BOXMetadataDeleteRequest instance that allows users
 * to delete metadata information on a given file.
 *
 * **NOTE** Scope is defaulted to @see BOXAPIScopeEnterprise in this initializer.
 *
 * @param fileID The ID of the desired file.
 * @param template The templateKey of the desired metadata information for the given file.
 *
 * @return A BOXMetadataDeleteRequest that allows users to delete metadata information on a given file.
 */
- (instancetype)initWithFileID:(NSString *)fileID template:(NSString *)templateName;

/**
 * Designated initializer. Returns a BOXMetadataDeleteRequest instance that allows users
 * to delete metadata information on a given file.
 *
 * @param fileID The ID of the desired file.
 * @param scope The scope of the templates desired for deleting metadata.
 * @param template The templateKey of the desired metadata information for the given file.
 *
 * @return A BOXMetadataDeleteRequest that allows users to delete metadata information on a given file.
 */
- (instancetype)initWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName;


/**
 * Performs the DELETE request to delete the specified metadata information.
 *
 * @param completionBlock The block of code to be run after the DELETE request has completed
 *                        regardless of success.
 */
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
