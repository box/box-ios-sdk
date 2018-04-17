//
//  BOXRepresentationInfoRequest.h
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 4/10/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>
@class BOXRepresentation;

@interface BOXRepresentationInfoRequest : BOXRequest
- (instancetype)initWithRepresentation:(BOXRepresentation *) representation;
- (void)performRequestWithCompletion:(BOXRepresentationInfoBlock)completionBlock;
@end
