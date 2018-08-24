//
//  BOXRepresentationsHelper.h
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 8/24/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXRepresentationsHelper : NSObject
/**
 Setting a representation or list option will include availability of file with request representation information
 */
@property (nonatomic, readwrite, strong) NSMutableOrderedSet *representationsRequested;

/**
 Setting a representation or Array of options will include availability for that file when request representation information
 */
- (void)setRepresentationRequestOptions:(NSArray *)representationOptions;
- (NSString *)formatRepresentationRequestHeader;
@end
