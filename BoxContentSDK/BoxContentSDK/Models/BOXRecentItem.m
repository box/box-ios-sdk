//
//  BOXRecentItem.m
//  Pods
//
//  Created by Andrew Dempsey on 12/19/16.
//
//

#import "BOXRecentItem.h"

@implementation BOXRecentItem

- (instancetype)initWithJSON:(NSDictionary *)JSONData
{
    if (self = [super initWithJSON:JSONData]) {
        NSDictionary *itemDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyItem
                                                                      inDictionary:JSONData
                                                                   hasExpectedType:[NSDictionary class]
                                                                       nullAllowed:NO];


        if ([itemDictionary[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeFile]) {
            self.item = [[BOXFile alloc] initWithJSON:itemDictionary];

        } else if ([itemDictionary[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeWebLink]) {
            self.item = [[BOXBookmark alloc] initWithJSON:itemDictionary];

        } else {
            BOXLog(@"Type %@ is not supported for recent items.", itemDictionary[BOXAPIObjectKeyType]);
        }

        self.interactionType = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyInteractionType
                                                              inDictionary:JSONData
                                                           hasExpectedType:[NSString class]
                                                               nullAllowed:NO];

// FIXME (12/20/16): the API currently returns the interaction date in Unix Time format, but this will soon change to
// ISO-8601. In order to avoid hitting a type-checking assertion when this change is made on the back-end,
// this field will be left unpopulated until the type is finalized.
//        NSNumber *interactionDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyInteractedAt
//                                                                   inDictionary:JSONData
//                                                                hasExpectedType:[NSNumber class]
//                                                                    nullAllowed:NO];
//        NSTimeInterval interactionDateInterval = interactionDate.doubleValue;
//        self.interactionDate = [NSDate dateWithTimeIntervalSince1970:interactionDateInterval];

        NSString *sharedLinkString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySharedLink
                                                                    inDictionary:JSONData
                                                                 hasExpectedType:[NSString class]
                                                                     nullAllowed:YES
                                                               suppressNullAsNil:YES];
        if (sharedLinkString != nil) {
            self.sharedLinkURL = [NSURL URLWithString:sharedLinkString];
        }
    }

    return self;
}

@end
