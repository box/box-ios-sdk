//
//  BOXEvent.m
//  BoxContentSDK
//
//  Created on 12/16/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXEvent.h"
#import "BOXUser.h"
#import "BOXFile.h"
#import "BOXBookmark.h"
#import "BOXFolder.h"
#import "BOXComment.h"
#import "BOXCollaboration.h"
#import "BOXCollection.h"
#import "BOXContentSDKConstants.h"

@implementation BOXEvent

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeEvent], @"Invalid type for object.");
    
    if (self = [super initWithJSON:JSONResponse]) {
        
        self.modelID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyEventID
                                                      inDictionary:JSONResponse
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
        
        NSDictionary *creatorDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedBy 
                                                                         inDictionary:JSONResponse 
                                                                      hasExpectedType:[NSDictionary class] 
                                                                          nullAllowed:NO];
        self.creator = [[BOXUser alloc] initWithJSON:creatorDictionary];
        
        // createdAt
        NSString *createdAtDateString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSString class] 
                                                                        nullAllowed:NO];
        self.createdDate = [NSDate box_dateWithISO8601String:createdAtDateString];
        
        self.eventType = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyEventType
                                                        inDictionary:JSONResponse
                                                     hasExpectedType:[NSString class]
                                                         nullAllowed:NO];
        
        self.sessionID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySessionID
                                                        inDictionary:JSONResponse 
                                                     hasExpectedType:[NSString class]
                                                         nullAllowed:YES];
        
        NSDictionary *sourceDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySource 
                                                                        inDictionary:JSONResponse
                                                                     hasExpectedType:[NSDictionary class] 
                                                                         nullAllowed:NO];
        
        NSString *type = sourceDictionary[BOXAPIObjectKeyType];
        
        if ([type isEqualToString:BOXAPIItemTypeFile]) {
            self.source = [[BOXFile alloc] initWithJSON:sourceDictionary];
        } else if ([type isEqualToString:BOXAPIItemTypeFolder]) {
            self.source = [[BOXFolder alloc] initWithJSON:sourceDictionary];            
        } else if ([type isEqualToString:BOXAPIItemTypeComment]) {
            self.source = [[BOXComment alloc] initWithJSON:sourceDictionary];
        } else if ([type isEqualToString:BOXAPIItemTypeUser]) {
            self.source = [[BOXUser alloc] initWithJSON:sourceDictionary];
        } else if ([type isEqualToString:BOXAPIItemTypeCollection]) {
            self.source = [[BOXCollection alloc] initWithJSON:sourceDictionary];
        } else if ([type isEqualToString:BOXAPIItemTypeWebLink]) {
            self.source = [[BOXBookmark alloc] initWithJSON:sourceDictionary];
        } else if ([type isEqualToString:BOXAPIItemTypeCollaboration]) {
            self.source = [[BOXCollaboration alloc] initWithJSON:sourceDictionary];
        } else {
            BOXLog(@"The source item of the event is not handled.");
        }
    }
    return self;
}

@end
