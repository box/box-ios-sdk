//
//  BOXMetadataRequest.h
//  BoxContentSDK
//
//  Created on 6/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BOXContentSDK.h>
#import "BOXRequest.h"

/**
 * BOXMetdataRequest is a concrete implementation of BOXRequest that allows users to 
 * use the BOXContentSDK to retrieve metadata associated with a given file.
 * 
 * Currently the BOXContentSDK only supports the enterprise scope and templates are
 * determined by an enterprise by enterprise basis.
 *
 * More information can be found at the link below:
 * https://box-content.readme.io/#get-metadata
 * https://box-content.readme.io/#get-all-metadata
 */
@interface BOXMetadataRequest : BOXRequest

/**
 * Suppliable ETags for the HTTPRequests header.
 */
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;

/**
 * The template name for the given scope of the BOXMetadataRequest.
 *
 * Templates are handled on a enterprise by enterprise basis. To see available metadata 
 * templates @see BOXMetadataTemplateRequest.
 */
@property (nonatomic, readwrite, strong) NSString *templateName;

/**
 * The scope of the BOXMetadataRequest. Determines which templates are available.
 * 
 * Currently only enterprise and global are supported scopes within metadata.
 */
@property (nonatomic, readwrite, strong) NSString *scope;

/**
 * Designated initializer. Returns a BOXMetadataRequest instance that allows users 
 * to get metadata information on a given file.
 *
 * @param fileID The ID of the desired file.
 * @param scope The scope of the templates desired for retrieving metadata.
 * @param template The templateKey of the desired metadata information for the given file.
 *
 * @return A BOXMetadataRequest that allows users to get metadata information on a given file.
 */
- (instancetype)initWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName;

/**
 * Returns a BOXMetadataRequest instance that allows users
 * to get metadata information on a given file.
 *
 * **NOTE** Scope is defaulted to @see BOXAPIScopeEnterprise in this initializer.
 *
 * @param fileID The ID of the desired file.
 * @param template The templateKey of the desired metadata information for the given file.
 *
 * @return A BOXMetadataRequest that allows users to get metadata information on a given file.
 */
- (instancetype)initWithFileID:(NSString *)fileID template:(NSString *)templateName;

/**
 * Performs the GET request to retrieve the desired metadata information.
 * Perform API request and any cache update only if completionBlock is not nil
 *
 * @param completionBlock The block of code to be run after the GET request has completed
 *                        regardless of success.
 */
- (void)performRequestWithCompletion:(BOXMetadatasBlock)completionBlock;

@end
