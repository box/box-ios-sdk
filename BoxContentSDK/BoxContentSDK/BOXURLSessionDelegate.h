//
//  BOXURLSessionDelegate.h
//  BoxContentSDK
//
//  Created by James Lawton on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BOXAbstractSession;

typedef void (^BOXURLSessionDownloadCompletion)(NSString *taskID, NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error);
typedef void (^BOXURLSessionUploadCompletion)(NSString *taskID, NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

/**
 * Handles delegate methods of background `NSURLSession`, supporting downloads and uploads.
 */
@interface BOXURLSessionDelegate : NSObject <NSURLSessionDelegate>

/**
 * Initialise with an abstract session, which will be used for token refresh. The abstract session is not retained.
 */
- (instancetype)initWithAbstractSession:(BOXAbstractSession *)abstractSession;

/**
 * The abstract session used for token refresh.
 */
@property (nonatomic, nullable, readonly, weak) BOXAbstractSession *abstractSession;

@property (atomic, copy, nullable) BOXURLSessionDownloadCompletion downloadDidComplete;

@property (atomic, copy, nullable) BOXURLSessionUploadCompletion uploadDidComplete;

/**
 * Associate a task with an identifier that means something to the delegate.
 */
- (void)associateTask:(NSURLSessionTask *)task withIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
