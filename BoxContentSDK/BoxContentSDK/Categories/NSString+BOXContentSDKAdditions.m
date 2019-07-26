//
//  NSString+BOXAdditions.m
//  BoxContentSDK
//
//  Created on 6/3/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

long long const BOX_KILOBYTE = 1024;
long long const BOX_MEGABYTE = BOX_KILOBYTE * 1024;
long long const BOX_GIGABYTE = BOX_MEGABYTE * 1024;
long long const BOX_TERABYTE = BOX_GIGABYTE * 1024;

#import "NSString+BOXContentSDKAdditions.h"

@implementation NSString (BOXContentSDKAdditions)

+ (NSString *)box_humanReadableStringForByteSize:(NSNumber *)size
{
    NSString * result_str = nil;
	long long fileSize = [size longLongValue];
    
    if (fileSize >= BOX_TERABYTE) 
    {
        double dSize = fileSize / (double)BOX_TERABYTE;
		result_str = [NSString stringWithFormat:NSLocalizedString(@"%1.1f TB", @"File size in terabytes (example: 1 TB)"), dSize];
    } else if (fileSize >= BOX_GIGABYTE) {
		double dSize = fileSize / (double)BOX_GIGABYTE;
		result_str = [NSString stringWithFormat:NSLocalizedString(@"%1.1f GB", @"File size in gigabytes (example: 1 GB)"), dSize];
	} else if (fileSize >= BOX_MEGABYTE) {
		double dSize = fileSize / (double)BOX_MEGABYTE;
		result_str = [NSString stringWithFormat:NSLocalizedString(@"%1.1f MB", @"File size in megabytes (example: 1 MB)"), dSize];
	} else if (fileSize >= BOX_KILOBYTE) {
		double dSize = fileSize / (double)BOX_KILOBYTE;
		result_str = [NSString stringWithFormat:NSLocalizedString(@"%1.1f KB", @"File size in kilobytes (example: 1 KB)"), dSize];
	} else if(fileSize > 0) {
        result_str = [NSString stringWithFormat:NSLocalizedString(@"%1.1f B", @"File size in bytes (example: 1 B)"), fileSize];
    } else {
		result_str = NSLocalizedString(@"Empty", @"File size 0 bytes");
	}
    
    return result_str;
}

- (BOOL)box_isEmptyOrWhitespacesOnly
{
    NSCharacterSet *nonWhitespaceCharacterSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
    BOOL isEmptyOrWhitespaces = ([self length] == 0 ||
                                 [self rangeOfCharacterFromSet:nonWhitespaceCharacterSet].location == NSNotFound);
    return isEmptyOrWhitespaces;
}

- (NSString *)box_pathExtensionAccountingForMultipleExtensionsAndEmptyName
{
    // pathExtension returns an empty string if there are no characters before the pathExtension (e.g ".jpg" or ".m4a")
    // Just simulating a correct name to correctly find the extension, since they are still valid files that can be previewed.
    NSString *tmp = [NSString stringWithFormat:@"tmp%@", self.lastPathComponent];
    NSString *string = [tmp box_pathExtensionAccountingForZippedPackages];
    
    return string;
}

- (NSString *)box_pathExtensionAccountingForZippedPackages
{
    NSString *extension = nil;
    
    if ([self box_hasTwoFileExtensions]) {
        extension = [[self stringByDeletingPathExtension] pathExtension];
    } else {
        extension = [self pathExtension];
    }
    
    return extension;
}

- (BOOL)box_hasTwoFileExtensions
{
    NSString *tmp = self;
    // So far we have 5 cases : .pages.zip, .key.zip, .keynote.zip, .numbers.zip, .rtfd.zip.
    if ([[tmp pathExtension] isEqualToString:@"zip"]) {
        tmp = [tmp stringByDeletingPathExtension];
        
        if ([[tmp pathExtension] isEqualToString:@"pages"] || [[tmp pathExtension] isEqualToString:@"key"] || [[tmp pathExtension] isEqualToString:@"keynote"] || [[tmp pathExtension] isEqualToString:@"numbers"] || [[tmp pathExtension] isEqualToString:@"rtfd"]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)box_stringByTrimmingTrailingSpaces
{
    NSString *tmp = self;
    
    if (self.length > 0 && ([self characterAtIndex:(self.length - 1)] == ' ')) {
        NSError *error = nil;
        // Regex to look for white-spaces at the end of string
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" +$" options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!error) {
            // Search for trailing white-spaces in a string and replace trailing white-spaces with empty string
            tmp = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
        }
    }
    
    return tmp;
}

- (NSString *)box_stringByDeletingMultiplePathExtensionsIfNecessary
{
    NSString *tmp = self;
    tmp = [tmp stringByDeletingPathExtension];
    
    if ([self box_hasTwoFileExtensions]) {
        tmp = [tmp stringByDeletingPathExtension];
    }
    
    return tmp;
}

- (NSString *)box_stringByAddingURLPercentEscapes
{
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]{}"] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

@end
