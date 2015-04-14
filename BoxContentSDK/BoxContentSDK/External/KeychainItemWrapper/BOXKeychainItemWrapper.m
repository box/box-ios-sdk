/*
 File: KeychainItemWrapper.m
 Abstract:
 Objective-C wrapper for accessing a single keychain item.
 
 Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "BOXKeychainItemWrapper.h"
#import <Security/Security.h>
#import "BOXLog.h"

/*
 
 These are the default constants and their respective types,
 available for the kSecClassGenericPassword Keychain Item class:
 
 kSecAttrAccessGroup            -        CFStringRef
 kSecAttrCreationDate        -        CFDateRef
 kSecAttrModificationDate    -        CFDateRef
 kSecAttrDescription            -        CFStringRef
 kSecAttrComment                -        CFStringRef
 kSecAttrCreator                -        CFNumberRef
 kSecAttrType                -        CFNumberRef
 kSecAttrLabel                -        CFStringRef
 kSecAttrIsInvisible            -        CFBooleanRef
 kSecAttrIsNegative            -        CFBooleanRef
 kSecAttrAccount                -        CFStringRef
 kSecAttrService                -        CFStringRef
 kSecAttrGeneric                -        CFDataRef
 
 See the header file Security/SecItem.h for more details.
 
 */

#define kBOXSecIdentifier ((id) @"com.box.sdk.keychain")

@interface BOXKeychainItemWrapper ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, readwrite, retain) NSMutableDictionary *genericPasswordQuery;
@property (nonatomic, readwrite, retain) NSString *identifier;
@property (nonatomic, readwrite, retain) NSString *accessGroup;

/*
 The decision behind the following two methods (secItemFormatToDictionary and dictionaryToSecItemFormat) was
 to encapsulate the transition between what the detail view controller was expecting (NSString *) and what the
 Keychain API expects as a validly constructed container class.
 */
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

// Updates the item in the keychain, or adds it if it doesn't exist.
- (void)writeToKeychain;

// Helper method
- (NSMutableDictionary *)defaultKeychainItemDataDictionaryWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;

@end

@implementation BOXKeychainItemWrapper

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup
{
    if (self = [super init])
    {
        self.identifier = identifier;
        self.accessGroup = accessGroup;
        
        // Begin Keychain search setup. The genericPasswordQuery leverages the special user
        // defined attribute kSecAttrGeneric to distinguish itself between other generic Keychain
        // items which may be included by the same application.
        self.genericPasswordQuery = [NSMutableDictionary dictionary];
        
        [self.genericPasswordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [self.genericPasswordQuery setObject:identifier forKey:(id)kSecAttrGeneric];
        [self.genericPasswordQuery setObject:identifier forKey:(id)kSecAttrAccount];
        [self.genericPasswordQuery setObject:kBOXSecIdentifier forKey:(id)kSecAttrService];
        
        // The keychain access group attribute determines if this item can be shared
        // amongst multiple apps whose code signing entitlements contain the same keychain access group.
        if (accessGroup != nil)
        {
#if TARGET_IPHONE_SIMULATOR
            // Ignore the access group if running on the iPhone simulator.
            //
            // Apps that are built for the simulator aren't signed, so there's no keychain access group
            // for the simulator to check. This means that all apps can see all keychain items when run
            // on the simulator.
            //
            // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
            // simulator will return -25243 (errSecNoAccessForItem).
#else
            [self.genericPasswordQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
        }
        
        // Use the proper search constants, return only the attributes of the first match.
        [self.genericPasswordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [self.genericPasswordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:self.genericPasswordQuery];
        
        NSMutableDictionary *outDictionary = nil;
        
        OSStatus result = SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary);
        if (result != noErr)
        {
            // Stick these default values into keychain item if nothing found.
            self.keychainItemData = [self defaultKeychainItemDataDictionaryWithIdentifier:identifier
                                                                              accessGroup:accessGroup];
        }
        else
        {
            // load the saved data from Keychain.
            self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
        }
        
        [outDictionary release];
    }
    
    return self;
}

- (void)dealloc
{
    [_keychainItemData release];
    _keychainItemData = nil;
    [_genericPasswordQuery release];
    _genericPasswordQuery = nil;
    
    [_identifier release];
    _identifier = nil;
    [_accessGroup release];
    _accessGroup = nil;
    
    [super dealloc];
}

- (void)setObject:(id)inObject forKey:(id)key
{
    @synchronized(self) {
        if (inObject == nil) return;
        id currentObject = [self.keychainItemData objectForKey:key];
        if (![currentObject isEqual:inObject])
        {
            [self.keychainItemData setObject:inObject forKey:key];
            [self writeToKeychain];
        }
    }
}

- (id)objectForKey:(id)key
{
    @synchronized(self) {
        return [self.keychainItemData objectForKey:key];
    }
}

- (void)resetKeychainItem
{
    @synchronized(self) {
        OSStatus junk = noErr;
        if (self.keychainItemData != nil)
        {
            NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:self.keychainItemData];
            junk = SecItemDelete((CFDictionaryRef)tempDictionary);
            
            NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
            // Default data for keychain item.
            self.keychainItemData = [self defaultKeychainItemDataDictionaryWithIdentifier:self.identifier
                                                                              accessGroup:self.accessGroup];
        }
    }
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for a SecItem.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the Generic Password keychain item class attribute.
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Convert the NSString to NSData to meet the requirements for the value type kSecValueData.
    // This is where to store sensitive data that should be encrypted.
    NSString *passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for the UI element.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Acquire the password data from the attributes.
    NSData *passwordData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)returnDictionary, (CFTypeRef *)&passwordData) == noErr)
    {
        // Remove the search, class, and identifier key/value, we don't need them anymore.
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        
        // Add the password to the dictionary, converting from NSData to NSString.
        NSString *password = [[[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length]
                                                     encoding:NSUTF8StringEncoding] autorelease];
        [returnDictionary setObject:password forKey:(id)kSecValueData];
    }
    else
    {
        // Don't do anything if nothing is found.
        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
    }
    
    [passwordData release];
    
    return returnDictionary;
}

- (void)overwriteKeychainItem
{
    OSStatus result = noErr;
    NSMutableDictionary *itemDataForDeletingFromKeychain = [self defaultKeychainItemDataDictionaryWithIdentifier:self.identifier
                                                                                                     accessGroup:self.accessGroup];
    NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:itemDataForDeletingFromKeychain];
    result = SecItemDelete((CFDictionaryRef)tempDictionary);
    
    if ((result != noErr) && (result != errSecItemNotFound)) {
        BOXLog(@"Keychain overwrite failed. Failed to delete keychain item with error %d", (int)result);
    }
    
    // No previous item found; add the new one.
    NSMutableDictionary *query = [self dictionaryToSecItemFormat:self.keychainItemData];
    if (self.isBackupDisabled) {
        [query setObject:(id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(id)kSecAttrAccessible];
    } else {
        [query setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
    }
    
    result = SecItemAdd((CFDictionaryRef)query, NULL);
    if (result != noErr) {
        BOXLog(@"Keychain overwrite failed. Failed to add keychain item with error %d", (int)result);
    }
}


- (void)writeToKeychain
{
    NSDictionary *attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
    
    OSStatus result = SecItemCopyMatching((CFDictionaryRef)self.genericPasswordQuery, (CFTypeRef *)&attributes);
    if (result == noErr)
    {
        // First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        // Second we need to add the appropriate search key/values.
        [updateItem setObject:[self.genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:self.keychainItemData];
        [tempCheck removeObjectForKey:(id)kSecClass];
        if (self.isBackupDisabled) {
            [tempCheck setObject:(id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(id)kSecAttrAccessible];
        } else {
            [tempCheck setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
        }
        
#if TARGET_IPHONE_SIMULATOR
        // Remove the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        [tempCheck removeObjectForKey:(id)kSecAttrAccessGroup];
#endif
        
        // An implicit assumption is that you can only update a single item at a time.
        
        result = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
        BOXAssert( result == noErr, @"Couldn't update the Keychain Item with error %d.", (int)result);
    }
    else
    {
        // No previous item found; add the new one.
        NSMutableDictionary *query = [self dictionaryToSecItemFormat:self.keychainItemData];
        
        if (self.isBackupDisabled) {
            [query setObject:(id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(id)kSecAttrAccessible];
        } else {
            [query setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
        }
        result = SecItemAdd((CFDictionaryRef)query, NULL);
        BOXAssert( result == noErr, @"Couldn't add the Keychain Item with error %d.", (int)result);
    }
    
    // if keychain operations failed, attempt to delete and retry it again.
    if (result != noErr)
    {
        [self overwriteKeychainItem];
    }
    
    [attributes release];
}

- (NSMutableDictionary *)defaultKeychainItemDataDictionaryWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup
{
    NSMutableDictionary *defaultDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    // Add the generic attribute and the keychain access group.
    // Also add AttrAccount wher we store identifier and kSecAttrService
    // Keychain is matching entries by kSetAttrService, as well as kSecAttrAccount
    // kSecAttrGeneric doesn't participate in matching
    // Thus to support multiple entries with different identifiers, we should also use
    // kSecAttrAccount and set kSetAttrService.
    // More info here: http://stackoverflow.com/questions/4891562/
    [defaultDictionary setObject:identifier forKey:(id)kSecAttrGeneric];
    [defaultDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    [defaultDictionary setObject:kBOXSecIdentifier forKey:(id)kSecAttrService];
    if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [defaultDictionary setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
    }
    // Set the value data field to a default empty value
    [defaultDictionary setObject:@"" forKey:(id)kSecValueData];
    
    return defaultDictionary;
}

@end
