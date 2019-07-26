//
//  NSURL+BOXURLHelper.m
//  BoxContentSDK
//
//  Created on 2/25/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXLog.h"
#import "NSURL+BOXURLHelper.h"

@implementation NSURL (BOXURLHelper)

- (NSDictionary *)box_queryDictionary
{
    return [[self class] box_queryDictionaryWithString:self.query];
}

+ (NSDictionary *)box_queryDictionaryWithString:(NSString *)queryString
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *keyValuePairs = [queryString componentsSeparatedByString:@"&"];
    NSArray *keyValuePairComponents = nil;

    for (NSString *keyValuePair in keyValuePairs)
    {
        keyValuePairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if (keyValuePairComponents.count == 2) {
            params[keyValuePairComponents[0]] = [keyValuePairComponents[1] stringByRemovingPercentEncoding];
        }
    }

    return [NSDictionary dictionaryWithDictionary:params];
}

@end
