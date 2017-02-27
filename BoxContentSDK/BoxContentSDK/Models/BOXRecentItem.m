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

        NSString *interactionDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyInteractedAt
                                                                   inDictionary:JSONData
                                                                hasExpectedType:[NSString class]
                                                                    nullAllowed:NO];
        self.interactionDate = [NSDate box_dateWithISO8601String:interactionDate];

        NSString *sharedLinkString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyInteractionSharedLink
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
