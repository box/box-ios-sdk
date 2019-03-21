//
//  BOXModelTestCase.h
//  BoxContentSDK
//
//  Created by Rico Yao on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

@import BoxContentSDKTestFramework;

@interface BOXModelTestCase : BOXContentSDKTestCase

- (NSDictionary *)dictionaryFromCannedJSON:(NSString *)cannedName;

@end
