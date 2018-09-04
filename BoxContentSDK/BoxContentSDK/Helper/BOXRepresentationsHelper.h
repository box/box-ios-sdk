//
//  BOXRepresentationsHelper.h
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 8/24/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXContentSDKConstants.h"

@protocol RepresentationsRequesting
- (void)setRepresentationRequestOptions:(NSArray*) representationOptions;
@end

@interface BOXRepresentationsHelper : NSObject

- (void)setRepresentationRequestOptions:(NSArray*) representationOptions;
- (NSString *)formatRepresentationRequestHeader;
- (NSString *) getRepresentationsFieldString;
@end
