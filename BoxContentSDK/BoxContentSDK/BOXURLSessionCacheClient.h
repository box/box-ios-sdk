//
//  BOXURLSessionCacheClient.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 3/3/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXURLSessionTaskCachedInfo : NSObject

@property (nonatomic, strong, readwrite) NSString *backgroundSessionId;
@property (nonatomic, assign, readwrite) NSUInteger sessionTaskId;
@property (nonatomic, strong, readwrite) NSString *destinationFilePath;
@property (nonatomic, strong, readwrite) NSData *resumeData;
@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@protocol BOXURLSessionCacheClientDelegate <NSObject>

// allow delegate to encrypt data before BOXURLSessionCacheClient persists it to disk
- (NSData *)encryptData:(NSData *)data;

// allow delegate to decrypt data which was encrypted by encryptData method above
- (NSData *)decryptData:(NSData *)data;

@end

/**
 * BOXURLSessionCacheClient is used to persist data for background download/upload session tasks to provide to task delegates
 * for processing once the task delegates are ready.
 *
 * BOXURLSessionCacheClient will require a root directory to cache its data at initialization, and it will create the sub directory
 * structures to persist data accordingly.
 *
 * 1. To store data specific to a background session task uniquely identified by background session id and session task id,
 * we use sub-directory /sessions/$backgroundSessionId/$sessionTaskId, which will contain up to 5 files:
 *
 * - destinationFilePath: store the destination file path of downloaded file, applicable for background download task only
 * - resumeData:          store the resume data of background download task which allows us to resume
 *                        download from the point before the task was cancelled, applicable for background
 *                        download task only
 * - responseData:        store the response data (could contain error from server)
 * - response:            store NSURLResponse
 * - error:               store client-side NSError
 *
 * 2. To keep track of whose user and its associateId the session task belongs to, we save backgroundSessionId and sessionTaskId
 * as a file name under sub-directory /users/$userId/$associateId with format $backgroundSessionId-$sessionTaskId
 */
@interface BOXURLSessionCacheClient : NSObject

@property (nonatomic, weak, readwrite) id<BOXURLSessionCacheClientDelegate> delegate;

/**
 * Cache the relationship between the session task and the user who started it as well as its equivalent associateId
 *
 * @param userId                Id of user started the session task
 * @param associateId           Id to associate with the session task
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param error                 error if fail to get
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheUserId:(NSString *)userId associateId:(NSString *)associateId backgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId error:(NSError **)error;

/**
 * Cache destinationFilePath of a background download session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param destinationFilePath   destination file path of downloaded file, applicable for background download task only
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId destinationFilePath:(NSString *)destinationFilePath error:(NSError **)error;

/**
 * Cache resumeData of of a background download session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param resumeData            resume data to resume background download session task from
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId resumeData:(NSData *)resumeData error:(NSError **)error;

/**
 * Cache responseData of a background session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param responseData          response data from the session task
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId responseData:(NSData *)responseData error:(NSError **)error;

/**
 * Cache response of a background session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param response              NSURLResponse from the session task
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId response:(NSURLResponse *)response error:(NSError **)error;

/**
 * Cache client-side error of a background session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param taskError             store client-side NSError of the session task
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId taskError:(NSData *)taskError error:(NSError **)error;

/**
 * Get all cached data of the background session task associated with this userId and associateId
 *
 * @param userId            Id of user started the session task
 * @param associateId       Id to associate with the session task
 * @param error             error if fail to get
 *
 * @return BOXURLSessionTaskCache   all cached data of the session task
 */
- (BOXURLSessionTaskCachedInfo *)getCacheForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error;

/**
 * Delete all cached data of the background session task associated with this userId and associateId
 *
 * @param userId            Id of user started the session task
 * @param associateId       Id to associate with the session task
 * @param error             error if fail to delete
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)deleteCachedInfoForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error;

@end
