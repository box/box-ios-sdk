//
//  BOXRepresentationDownloadRequest.h
//  BoxContentSDK
//
//  Created by Clement Rousselle on 3/2/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXRequestWithSharedLinkHeader.h"

@class BOXRepresentation;

@interface BOXFileRepresentationDownloadRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *versionID;
@property (nonatomic, readwrite, assign) BOOL ignoreLocalURLRequestCache;

- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID
                          representation:(BOXRepresentation *)representation;

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID
                      representation:(BOXRepresentation *)representation;

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock;

@end
