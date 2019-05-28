//
//  BOXUserAvatarImageView.m
//  BoxContentSDK
//
//  Created by Rico Yao on 9/27/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXUserAvatarImageView.h"
#import "BOXUserAvatarRequest.h"
#import "BOXContentClient+User.h"
#import "BOXContentCacheClientProtocol.h"

typedef enum {
    BOXCircularAvatarBackgroundShadeSoftMagenta = 0,
    BOXCircularAvatarBackgroundShadeSoftCyan,
    BOXCircularAvatarBackgroundShadeLightRed,
    BOXCircularAvatarBackgroundShadeModerateGreen,
    BOXCircularAvatarBackgroundShadeVividViolet,
    BOXCircularAvatarBackgroundShadeLightOrange,
    BOXCircularAvatarBackgroundShadeBrightRed,
    BOXCircularAvatarBackgroundShadeLimeGreen,
    BOXCircularAvatarBackgroundShadeSoftPink,
    BOXCircularAvatarBackgroundShadeModerateBlue,
    BOXCircularAvatarBackgroundShadeDarkOrange,
    BOXCircularAvatarBackgroundShadeDesaturatedBlue,
    BOXCircularAvatarBackgroundShadeModerateLimeGreen,
    BOXCircularAvatarBackgroundShadeBrightYellow,
    BOXCircularAvatarBackgroundShadeSoftBlue,
    BOXCircularAvatarBackgroundShadeDarkViolet,
    BOXCircularAvatarBackgroundShadeBrightOrange,
    BOXCircularAvatarBackgroundShadeVividOrange,
    BOXCircularAvatarBackgroundShadeCount,
} BOXCircularAvatarBackgroundShade;

@interface BOXUserAvatarImageView()
@property (nonatomic, readwrite, strong) BOXUserAvatarRequest *request;
@end

@implementation BOXUserAvatarImageView

- (instancetype)initWithFrame:(CGRect)frame
                         user:(BOXUserMini *)user
                       client:(BOXContentClient *)client
{
    if (self = [super initWithFrame:frame]) {
        _user = user;
        _client = client;
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;

        if (user) {
            [self render];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                       client:(BOXContentClient *)client
{
    self = [self initWithFrame:frame user:nil client:client];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width / 2;
}

- (void)setUser:(BOXUserMini *)user
{
    if (user.modelID.length > 0) {
        NSString *oldUserID = _user.modelID;
        _user = user;
        if (![oldUserID isEqualToString:user.modelID]) {
            [self render];
        }
    }
}

#pragma mark - Private helpers

- (void)render
{
    if (self.user.modelID.length > 0) {
        [self.request cancel];
        BOXUserAvatarRequest *request = [self.client userAvatarRequestWithID:self.user.modelID
                                                                        type:BOXAvatarTypePreview];
        id<BOXContentCacheClientProtocol> cacheClient = [self.client cacheClient];
        __weak BOXUserAvatarImageView *me = self;
        if ([cacheClient respondsToSelector:@selector(retrieveCacheForUserAvatarRequest:completion:)]) {
            [cacheClient retrieveCacheForUserAvatarRequest:request
                                                completion:^(UIImage *image, NSError *error) {
                                                    if (image && !error) {
                                                        [me renderImage:image];
                                                    } else {
                                                        [me renderNameBasedAvatar];
                                                        [me renderRealUserAvatarFromRemote:request];
                                                    }
                                                }];
        } else {
            [self renderNameBasedAvatar];
            [self renderRealUserAvatarFromRemote:request];
        }
    }
}

- (void)renderNameBasedAvatar
{
    UIImage *image = [self nameBasedAvatarForUser:self.user size:self.bounds.size];
    [self renderImage:image];
}

- (void)renderRealUserAvatarFromRemote:(BOXUserAvatarRequest *)request
{
    __weak BOXUserAvatarImageView *me = self;
    self.request = request;
    [self.request performRequestWithProgress:nil completion:^(UIImage *image, NSError *error) {
        if (image && !error) {
            [me renderImage:image];
        } else {
            [me renderNameBasedAvatar];
        }
    }];
}

- (void)refresh
{
    if (self.user.modelID.length > 0) {
        [self.request cancel];
        BOXUserAvatarRequest *request = [self.client userAvatarRequestWithID:self.user.modelID type:BOXAvatarTypePreview];
        [self renderRealUserAvatarFromRemote:request];
    }
}

- (void)dealloc
{
    [self.request cancel];
    self.request = nil;
}

- (void)renderImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = image;
        [self setNeedsLayout];
    });
}

#pragma mark - Helpers for name-based avatar

- (UIImage *)nameBasedAvatarForUser:(BOXUserMini *)user size:(CGSize)size
{
    BOXCircularAvatarBackgroundShade shade = [user.modelID longLongValue] % BOXCircularAvatarBackgroundShadeCount;
    return [self imageRenderedWithSize:size
                       backgroundShade:shade
                                  name:user.name
                        textAttributes:nil];
}

- (UIImage *)imageRenderedWithSize:(CGSize)size
                   backgroundColor:(UIColor *)backgroundColor
                              name:(NSString *)name
                    textAttributes:(NSDictionary *)attributes
{
    NSAttributedString *attributedName = nil;
    NSString *initials = [self initialsFromName:name];
    
    if (initials) {
        if (attributes == nil) {
            attributes = [self avatarNameAttributes];
        }
        attributedName = [[NSAttributedString alloc] initWithString:initials attributes:attributes];
    }
    CGRect rect = CGRectZero;
    rect.size = size;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillEllipseInRect(context, rect);
    
    if (attributedName.length > 0) {
        CGSize textSize = attributedName.size;
        CGFloat textHeight = ceil(MIN(textSize.height, rect.size.height));
        
        CGRect textRect = rect;
        textRect.origin.y = floor(CGRectGetMidY(textRect) - textHeight * 0.5f);
        textRect.size.height = textHeight;
        [attributedName drawInRect:textRect];
    }
    
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (UIImage *)imageRenderedWithSize:(CGSize)size
                   backgroundShade:(BOXCircularAvatarBackgroundShade)backgroundShade
                              name:(NSString *)name
                    textAttributes:(NSDictionary *)attributes
{
    BOXCircularAvatarBackgroundShade shadeIndex = backgroundShade % BOXCircularAvatarBackgroundShadeCount;
    UIColor *backgroundColor = [[self avatarBackgroundColors] objectAtIndex:shadeIndex];
    return [self imageRenderedWithSize:size
                       backgroundColor:backgroundColor
                                  name:name
                        textAttributes:attributes];
}

- (NSArray *)avatarBackgroundColors
{
    static NSArray *avatarBackgroundColors = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        avatarBackgroundColors = @[[UIColor colorWithRed:222.0/255.0f green:127.0/255.0f blue:241.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:99.0/255.0f green:214.0/255.0f blue:228.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:255.0/255.0f green:95.0/255.0f blue:95.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:126.0/255.0f green:213.0/255.0f blue:74.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:175.0/255.0f green:33.0/255.0f blue:244.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:255.0/255.0f green:158.0/255.0f blue:87.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:229.0/255.0f green:67.0/255.0f blue:67.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:93.0/255.0f green:200.0/255.0f blue:167.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:242.0/255.0f green:113.0/255.0f blue:164.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:46.0/255.0f green:113.0/255.0f blue:182.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:226.0/255.0f green:111.0/255.0f blue:60.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:118.0/255.0f green:143.0/255.0f blue:186.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:86.0/255.0f green:193.0/255.0f blue:86.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:239.0/255.0f green:207.0/255.0f blue:46.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:77.0/255.0f green:198.0/255.0f blue:252.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:80.0/255.0f green:23.0/255.0f blue:133.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:238.0/255.0f green:104.0/255.0f blue:50.0/255.0f alpha:1.0f],
                                   [UIColor colorWithRed:255.0/255.0f green:177.0/255.0f blue:29.0/255.0f alpha:1.0f]];
    });
    
    return avatarBackgroundColors;
}

- (NSDictionary *)avatarNameAttributes
{
    static NSDictionary *avatarNameAttributes = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        avatarNameAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],
                                  NSParagraphStyleAttributeName : paragraphStyle };
    });
    
    return avatarNameAttributes;
}

// This function will take the First word and Last word in the name string as initials.
// Incorrect initials will be shown when a user has a multi-part last name or a suffix
// since there is no way of distinguishing whether a user has entered a middle name or falls
// into the above case. If we instead use initials from the first 2 words, we have the issue of
// showing incorrect initials when the user has entered a middle name.
- (NSString *)initialsFromName:(NSString *)name
{
    NSString *extractedInitials = nil;
    if (name) {
        NSMutableString *initialSubstring = [NSMutableString string];
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *nameComponents = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *firstName = [nameComponents firstObject];
        NSString *lastName = [nameComponents lastObject];
        if (firstName.length > 0) {
            [initialSubstring appendString:[firstName substringWithRange:[firstName rangeOfComposedCharacterSequenceAtIndex:0]]];
        }
        if (lastName.length > 0 && nameComponents.count > 1) {
            [initialSubstring appendString:[lastName substringWithRange:[lastName rangeOfComposedCharacterSequenceAtIndex:0]]];
        }
        
        // Check for non-letters first, then check canBeConvertedToEncoding:NSISOLatin1StringEncoding to detect foreign characters
        NSRange range = [initialSubstring rangeOfCharacterFromSet:[[NSCharacterSet letterCharacterSet] invertedSet]];
        
        if (initialSubstring.length > 0 && range.location == NSNotFound && [initialSubstring canBeConvertedToEncoding:NSISOLatin1StringEncoding]) {
            extractedInitials = initialSubstring;
        }
    }
    return extractedInitials.uppercaseString;
}

@end
