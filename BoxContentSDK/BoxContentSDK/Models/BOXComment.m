//
//  BOXComment.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/9/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXComment.h"
#import "BOXUser.h"
#import "BOXItem.h"
#import "BOXFile.h"
#import "BOXBookmark.h"

@implementation BOXComment


- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeComment], @"Invalid type for object.");
    
    if (self = [super initWithJSON:JSONResponse]) 
    {
        self.message = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyMessage
                                                      inDictionary:JSONResponse
                                                   hasExpectedType:[NSString class] 
                                                       nullAllowed:NO];
        
        self.taggedMessage = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyTaggedMessage
                                                            inDictionary:JSONResponse
                                                         hasExpectedType:[NSString class] 
                                                             nullAllowed:NO];
        
        // createdAt
        NSString *createdAtDateString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSString class] 
                                                                        nullAllowed:NO];
        self.createdDate = [NSDate box_dateWithISO8601String:createdAtDateString];
        
        
        // modifiedAt
        NSString *modifiedAtDateString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedAt
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSString class] 
                                                                        nullAllowed:NO];
        self.modifiedDate = [NSDate box_dateWithISO8601String:modifiedAtDateString];
        
        
        // item 
        NSDictionary *itemDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyItem
                                                                      inDictionary:JSONResponse
                                                                   hasExpectedType:[NSDictionary class] 
                                                                       nullAllowed:NO];
        if (itemDictionary) {
            if ([itemDictionary[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeFile]) {
                self.item = [[BOXFileMini alloc] initWithJSON:itemDictionary];
            }
            else if ([itemDictionary[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeWebLink]) {
                self.item = [[BOXBookmarkMini alloc] initWithJSON:itemDictionary];
            }
        }
        
        // createdBy
        NSDictionary *createdByDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedBy
                                                                           inDictionary:JSONResponse
                                                                        hasExpectedType:[NSDictionary class] 
                                                                            nullAllowed:NO];
        if (createdByDictionary) {
            self.creator = [[BOXUserMini alloc] initWithJSON:createdByDictionary];
        }
        
        
        // isReplyComment
        self.isReplyComment = BOXAPIBooleanUnknown;
        
        NSNumber *isReplyCommentNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsReplyComment
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSNumber class]
                                                                        nullAllowed:NO];
        if (isReplyCommentNumber) {
            self.isReplyComment = [isReplyCommentNumber boolValue] ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
    }
    
    return self;
}

@end
