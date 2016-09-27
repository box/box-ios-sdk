//
//  BOXModelTestCase.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"

@implementation BOXModelTestCase

- (NSDictionary *)dictionaryFromCannedJSON:(NSString *)cannedName
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:cannedName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [dictionary isKindOfClass:NSDictionary.class] ? dictionary : nil;
}

@end
