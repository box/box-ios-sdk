//
//  BOXRepresentation.m
//  BoxContentSDK
//
//  Created on 7/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXRepresentation.h"
#import "NSJSONSerialization+BOXContentSDKAdditions.h"
#import "BOXContentSDKConstants.h"

@implementation BOXRepresentation

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super init]) {
        
        self.JSONData = JSONResponse;
        
        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyRepresentation
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        NSDictionary *propertiesJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyProperties
                                                                      inDictionary:JSONResponse
                                                                   hasExpectedType:[NSDictionary class]
                                                                       nullAllowed:NO];
        
        self.dimensions = [propertiesJSON objectForKey:BOXAPIObjectKeyDimensions];
        
        NSDictionary *statusObject = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyStatus
                                                                    inDictionary:JSONResponse
                                                                 hasExpectedType:[NSDictionary class]
                                                                     nullAllowed:NO];
        
        self.status = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyState
                                                     inDictionary:statusObject
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        self.statusCode = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCode
                                                         inDictionary:statusObject
                                                      hasExpectedType:[NSString class]
                                                          nullAllowed:NO];
        
        NSDictionary *detailsJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDetails
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        self.details = detailsJSON;
        
        NSDictionary *contentJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyContent
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        
        NSString *contentURLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURLTemplate
                                                                    inDictionary:contentJSON
                                                                 hasExpectedType:[NSString class]
                                                                     nullAllowed:NO];
        if (contentURLString.length > 0) {
            NSString *replacementString = @"";

            if ([self.type isEqualToString:BOXRepresentationTypeHLS]) {
                replacementString = BOXRepresentationTemplateValueHLSManifest;
            }
            
            self.contentURL = [NSURL URLWithString:[contentURLString stringByReplacingOccurrencesOfString:BOXRepresentationTemplateKeyAccessPath withString:replacementString]];
        }
        
        NSDictionary *infoJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyInfo
                                                                inDictionary:JSONResponse
                                                             hasExpectedType:[NSDictionary class]
                                                                 nullAllowed:NO];
        
        NSString *infoURLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                      inDictionary:infoJSON
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
        if (infoURLString.length > 0) {
            self.infoURL = [NSURL URLWithString:infoURLString];
        }
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _type = [coder decodeObjectOfClass:[BOXRepresentationType class] forKey:NSStringFromSelector(@selector(type))];
        _status = [coder decodeObjectOfClass:[BOXRepresentationStatus class] forKey:NSStringFromSelector(@selector(status))];
        _statusCode = [coder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector((statusCode)))];
        _infoURL = [coder decodeObjectOfClass:[NSURL class] forKey:NSStringFromSelector(@selector(infoURL))];
        _contentURL = [coder decodeObjectOfClass:[NSURL class] forKey:NSStringFromSelector(@selector(contentURL))];
        _details = [coder decodeObjectOfClass:[NSDictionary class] forKey:NSStringFromSelector(@selector(details))];
        _dimensions = [coder decodeObjectOfClass:[BOXRepresentationImageDimensions class] forKey:NSStringFromSelector(@selector(dimensions))];
        _JSONData = [coder decodeObjectOfClass:[NSDictionary class] forKey:NSStringFromSelector(@selector(JSONData))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.type forKey:NSStringFromSelector(@selector(type))];
    [coder encodeObject:self.status forKey:NSStringFromSelector(@selector(status))];
    [coder encodeObject:self.statusCode forKey:NSStringFromSelector(@selector((statusCode)))];
    [coder encodeObject:self.infoURL forKey:NSStringFromSelector(@selector(infoURL))];
    [coder encodeObject:self.contentURL forKey:NSStringFromSelector(@selector(contentURL))];
    [coder encodeObject:self.details forKey:NSStringFromSelector(@selector(details))];
    [coder encodeObject:self.dimensions forKey:NSStringFromSelector(@selector(dimensions))];
    [coder encodeObject:self.JSONData forKey:NSStringFromSelector(@selector(JSONData))];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
