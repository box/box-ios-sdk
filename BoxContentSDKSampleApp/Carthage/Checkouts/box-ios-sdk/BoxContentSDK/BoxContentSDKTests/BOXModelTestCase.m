//
//  BOXModelTestCase.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXAPIJSONOperation.h"

@implementation BOXModelTestCase

- (NSDictionary *)dictionaryFromCannedJSON:(NSString *)cannedName
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:cannedName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    BOXAPIJSONOperation *dummyOperation = [[BOXAPIJSONOperation alloc] init];
    [dummyOperation processResponseData:data];
    NSDictionary *dictionary = dummyOperation.responseJSON;
    return dictionary;
}

@end
