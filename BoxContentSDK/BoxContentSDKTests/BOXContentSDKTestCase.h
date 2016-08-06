//
//  BoxContentSDKTestCase.h
//  BoxContentSDK
//
//  Created by Rico Yao on 11/21/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BoxContentSDK/BoxContentSDK.h>

@interface BOXContentSDKTestCase : XCTestCase

- (void)assertModel:(BOXModel *)modelA isEquivalentTo:(BOXModel *)modelB;

- (void)assertItemCollection:(NSArray *)itemCollectionA isEquivalentTo:(NSArray *)itemCollectionB;

- (void)assertSharedLink:(BOXSharedLink *)sharedLinkA isEquivalentTo:(BOXSharedLink *)sharedLinkB;

@end
