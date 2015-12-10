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
                result = NSLocalizedString(@"Unable to connect to Box. Please check your network connection and try again.", @"Messsage: message shown in alert view when loading folders failed due to network connection");
                break;
            default:
                result = NSLocalizedString(@"A network error occurred.", @"Narrative: Message explaining that a failure was caused by a network issue");
                break;
        }
    } else if ([self.domain isEqualToString:BOXContentSDKErrorDomain]) {
        
        switch (self.code) {
            case BOXContentSDKAPIErrorUnauthorized:
            case BOXContentSDKAPIErrorForbidden:
                result = NSLocalizedString(@"You do not have permission to perform this action.", @"Narrative: Message explaining that a failure happened because the user does not have sufficient permissions or access required to perform the action");
                break;
                
            case BOXContentSDKAPIErrorNotFound:
                result = NSLocalizedString(@"This item does not exist.", @"Narrative: Message explaining that a failure happened because the item does not exist");
                break;
                
            case BOXContentSDKAPIErrorConflict:
                result = NSLocalizedString(@"An item with the same name already exists.", @"Narrative: Message explaining that a failure happened because there is a naming conflict");
                break;
                
            default:
                break;
        }
    }
    
    if (result == nil) {
        result = NSLocalizedString(@"Unable to complete the requested action.", @"Narrative: Message explaining that a failure happened.");
    }
    
    return result;
}

- (NSString *)box_localizedShortFailureReasonString
{
    NSString *result = nil;

    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        switch (self.code) {
            case NSURLErrorNotConnectedToInternet:
                result = NSLocalizedString(@"No Network Connection", @"Label: Short title explaining that a failure happened because there is no network connection");
                break;
            default:
                result = NSLocalizedString(@"Network Issue", @"Label: Short title explaining that a failure was caused by a network issue");
                break;
        }
    } else if ([self.domain isEqualToString:BOXContentSDKErrorDomain]) {
        switch (self.code) {
            case BOXContentSDKAPIErrorUnauthorized:
            case BOXContentSDKAPIErrorForbidden:
                result = NSLocalizedString(@"Insufficient Permissions", @"Label: Short title explaining that a failure happened because the user does not have sufficient permissions or access required to perform the action");
                break;

            case BOXContentSDKAPIErrorConflict:
                result = NSLocalizedString(@"Naming Conflict", @"Label: Short title explaining that a failure happened because there is a naming conflict");
                break;

            case BOXContentSDKAPIErrorRequestEntityTooLarge:
                result =  NSLocalizedString(@"File Too Large", @"Label: Short title explaining that a failure happened because the associated file is larger than the user's maximum allowed file size for their account");
                break;

            case BOXContentSDKAPIErrorInsufficientStorage:
                result = NSLocalizedString(@"Not Enough Space", @"Label: Short title explaining that a failure happened because the user's account is full");
                break;

            case BOXContentSDKAPIErrorNotFound:
                result = NSLocalizedString(@"Item not Found", @"Label: Short title explaining that a failure happened because the item does not exist");
                break;

            default:
                break;
        }
    }

    if (result == nil) {
        result = NSLocalizedString(@"An Error Occurred", @"Label: Short title explaining that a failure happened.");
    }

    return result;
}

@end
