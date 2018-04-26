//
//  BOXRepresentation.h
//  BoxContentSDK
//
//  Created on 7/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXContentSDKConstants.h"

@interface BOXRepresentation : NSObject

@property (nonatomic, readwrite, strong) BOXRepresentationType *type;

@property (nonatomic, readwrite, strong) BOXRepresentationStatus *status;

@property (nonatomic, readwrite, strong) NSString *statusCode;

@property (nonatomic, readwrite, strong) NSURL *infoURL;

@property (nonatomic, readwrite, strong) NSURL *contentURL;

@property (nonatomic, readwrite, strong) NSDictionary *details;

@property (nonatomic, readwrite, strong) BOXRepresentationImageDimensions *dimensions;

/**
 *  JSON response data.
 */
@property (nonatomic, readwrite, strong) NSDictionary *JSONData;

/**
 *  Initialize with API JSON response dictionary.
 *
 *  @param JSONResponse Dictionary from JSON response.
 *
 *  @return BOXRepresentation instance.
 */
- (instancetype)initWithJSON:(NSDictionary *)JSONResponse;

@end
