//
//  NSError+BOXAdditions.m
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "NSError+BOXAdditions.h"
#import "BOXContentSDKErrors.h"

@implementation NSError (BOXAdditions)

- (NSString *)box_localizedFailureReasonString
{
    NSString *result = nil;
    
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        switch (self.code) {
            case NSURLErrorNotConnectedToInternet:
                result = NSLocalizedString(@"There was a problem connecting to Box. Please check your network connection.", @"Messsage: message shown in alert view when loading folders failed due to network connection");
                break;
            default:
                result = NSLocalizedString(@"A network error occurred.", @"Narrative: Message explaining that a failure was caused by a network issue");
                break;
        }
    } else if ([self.domain isEqualToString:BOXContentSDKErrorDomain]) {
        
        switch (self.code) {
            case BOXContentSDKAPIErrorUnauthorized:
            case BOXContentSDKAPIErrorForbidden:
                result = NSLocalizedString(@"You do not have the permissions to perform this action.", @"Narrative: Message explaining that a failure happened because the user does not have sufficient permissions or access required to perform the action");
                break;
                
            case BOXContentSDKAPIErrorNotFound:
                result = NSLocalizedString(@"The item does not exist.", @"Narrative: Message explaining that a failure happened because the item does not exist");
                break;
                
            case BOXContentSDKAPIErrorConflict:
                result = NSLocalizedString(@"An item with the same name already exists.", @"Narrative: Message explaining that a failure happened because there is a naming conflict");
                break;
                
            default:
                break;
        }
    }
    
    if (result == nil) {
        result = NSLocalizedString(@"Sorry, we could not complete the requested action.", @"Narrative: Message explaining that a failure happened.");
    }
    
    return result;
}

@end
