//
//  BOXSampleAppSessionManager.h
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 1/13/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXSampleAppSessionInfo : NSObject <NSCoding>

@property (nonatomic, strong, readwrite) NSString *associateId;
@property (nonatomic, strong, readwrite) NSString *destinationPath; //applicable for download task

- (id)initWithAssociateId:(NSString *)associateId destinationPath:(NSString *)destinationPath;

@end

@interface BOXSampleAppSessionManager : NSObject

+ (id)defaultManager;

- (BOXSampleAppSessionInfo *)getSessionTaskInfo:(NSUInteger)sessionTaskId;
- (void)saveSessionTaskId:(NSUInteger)sessionTaskId withInfo:(BOXSampleAppSessionInfo *)info;
- (void)removeSessionTaskId:(NSUInteger)sessionTaskId;

@end
