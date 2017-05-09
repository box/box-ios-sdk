//
//  BOXURLSessionCacheClient.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 3/3/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXURLSessionTaskCachedInfo : NSObject
//@see comments above BOXURLSessionCacheClient for detailed explaination of those properties

@property (nonatomic, strong, readwrite) NSString *backgroundSessionId;
@property (nonatomic, assign, readwrite) NSUInteger sessionTaskId;
@property (nonatomic, strong, readwrite) NSString *destinationFilePath;
@property (nonatomic, strong, readwrite) NSData *resumeData;
@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@interface BOXURLBackgroundSessionIdAndSessionTaskId : NSObject

@property (nonatomic, copy, readwrite) NSString *backgroundSessionId;
@property (nonatomic, assign, readwrite) NSUInteger sessionTaskId;

- (id)initWithBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId;

@end

@protocol BOXURLSessionCacheClientDelegate <NSObject>

@optional

// allow delegate to encrypt data before BOXURLSessionCacheClient persists it to disk
- (NSData *)encryptData:(NSData *)data;

// allow delegate to decrypt data which was encrypted by encryptData method above
- (NSData *)decryptData:(NSData *)data;

@end

/**
 * BOXURLSessionCacheClient is used to persist data for background download/upload session tasks to provide to task delegates
 * for processing once the task delegates are ready.
 *
 * BOXURLSessionCacheClient will require a root directory to cache its data at initialization, and it will create the
 * sub directory structures to persist data accordingly.
 *
 * 1. To store data specific to an on-going background session task uniquely identified by background session id
 * and session task id, we use sub-directory onGoingSessionTasks/$backgroundSessionId/$sessionTaskId,
 * which will contain up to 6 files:
 *
 * - destinationFilePath: store the destination file path of downloaded file, applicable for background download task only
 * - resumeData:          store the resume data of background download task which allows us to resume
 *                        download from the point before the task was cancelled, applicable for background
 *                        download task only
 * - responseData:        store the response data (could contain error from server)
 * - response:            store NSURLResponse
 * - error:               store client-side NSError
 * - userIdAndAssociateId:store userId and associateId that this session task associates with
 *                          (this file is only used internally to help refer back to $userId and $associateId
 *                          that started this session task)
 *
 * 2. To keep track of whose user and its associateId the session task belongs to, we save backgroundSessionId and sessionTaskId
 * as a file name under sub-directory users/$userId/$associateId/info with format $backgroundSessionId-$sessionTaskId
 *
 * 3. Once session tasks complete, their cached info under onGoingSessionTasks/$backgroundSessionId/$sessionTaskId dir
 * will be moved into users/$userId/$associateId/completed dir
 *
 * 4. Both app and extensions share the same cache hierarchy given associateId is expected to be globally unique
 * and app has a unique background session id, as well as extension has a unique background session id per run.
 * Once extension terminates and app takes over its background session, we will cache extension's background session id
 * under extensionSessions/$backgroundSessionId to allow the app to connect to background session tasks from extensions.
 *
 * NOTE: there can only be one on-going backgroundSessionId and sessionTaskId at any time,
 *       but there can be more than one completed session tasks with that backgroundSessionId and sessionTaskId
 *       under users/$userId/$associateId/completed/... until they are cleaned up
 */
@interface BOXURLSessionCacheClient : NSObject

/**
 * Initialize BOXURLSessionCacheClient with a root directory for all cache data.
 * Cannot be nil.
 */
- (id)initWithCacheRootDir:(NSString *)cacheRootDir;

/**
 * Delegate to allow encrypting data before persisting to disk, and can be left unset.
 */
@property (nonatomic, weak, readwrite) id<BOXURLSessionCacheClientDelegate> delegate;

/**
 * Cache the relationship between the session task and the user who started it as well as its equivalent associateId
 *
 * @param userId                Id of user started the session task. Cannot be nil
 * @param associateId           Id to associate with the session task. Cannot be nil
 * @param backgroundSessionId   Id of the background session. Cannot be nil
 * @param sessionTaskId         Id of the session task. Cannot be nil
 * @param error                 error if fail to get
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheUserId:(NSString *)userId associateId:(NSString *)associateId backgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId error:(NSError **)error;

/**
 * Cache destinationFilePath of a background download session task
 *
 * @param backgroundSessionId   Id of the background session. Cannot be nil
 * @param sessionTaskId         Id of the session task. Cannot be nil
 * @param destinationFilePath   destination file path of downloaded file, applicable for background download task only
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId destinationFilePath:(NSString *)destinationFilePath error:(NSError **)error;

/**
 * Cache resumeData of of a background download session task
 *
 * @param backgroundSessionId   Id of the background session. Cannot be nil
 * @param sessionTaskId         Id of the session task. Cannot be nil
 * @param resumeData            resume data to resume background download session task from
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId resumeData:(NSData *)resumeData error:(NSError **)error;

/**
 * Cache responseData of a background session task
 *
 * @param backgroundSessionId   Id of the background session. Cannot be nil
 * @param sessionTaskId         Id of the session task. Cannot be nil
 * @param responseData          response data from the session task
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId responseData:(NSData *)responseData error:(NSError **)error;

/**
 * Cache response of a background session task
 *
 * @param backgroundSessionId   Id of the background session. Cannot be nil
 * @param sessionTaskId         Id of the session task. Cannot be nil
 * @param response              NSURLResponse from the session task
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId response:(NSURLResponse *)response error:(NSError **)error;

/**
 * Cache client-side error of a background session task
 *
 * @param backgroundSessionId   Id of the background session. Cannot be nil
 * @param sessionTaskId         Id of the session task. Cannot be nil
 * @param taskError             store client-side NSError of the session task
 * @param error                 error if fail to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId taskError:(NSError *)taskError error:(NSError **)error;

/**
 * Get all cached data of the completed background session task associated with this userId and associateId
 *
 * @param userId            Id of user started the session task. Cannot be nil
 * @param associateId       Id to associate with the session task. Cannot be nil
 * @param outError          error if fail to get
 *
 * @return BOXURLSessionTaskCache   all cached data of the session task
 */
- (BOXURLSessionTaskCachedInfo *)completedCachedInfoForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)outError;

/**
 * Delete all cached data of the background session task associated with this userId and associateId
 *
 * @param userId            Id of user started the session task. Cannot be nil
 * @param associateId       Id to associate with the session task. Cannot be nil
 * @param error             error if fail to delete
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)deleteCachedInfoForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error;

/**
 * Get cached destination file path for a download session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 *
 * @return destination file path
 */
- (NSString *)destinationFilePathForBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId;

/**
 * Get cached response data for a session task
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 *
 * @return destination file path
 */
- (NSData *)responseDataForBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId;

/**
 * Get background session Id and session task Id associate with userId and associateId
 *
 * @param userId        Id of user started the session task
 * @param associateId   Id to associate with the session tas
 * @param error         error retrieving background session Id and session task Id
 *
 * @return BOXURLBackgroundSessionIdAndSessionTaskId associate with userId and associateId
 */
- (BOXURLBackgroundSessionIdAndSessionTaskId *)backgroundSessionIdAndSessionTaskIdForUserId:(NSString *)userId
                                                                                associateId:(NSString *)associateId
                                                                                      error:(NSError **)error;

/**
 * Call to complete a session task by moving its cached info from on-going session tasks' subdir into users' completed subdir
 *
 * @param backgroundSessionId   Id of the background session
 * @param sessionTaskId         Id of the session task
 * @param outError              error if fail to complete
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)completeSessionTaskForBackgroundSessionId:(NSString *)backgroundSessionId
                                    sessionTaskId:(NSUInteger)sessionTaskId
                                            error:(NSError **)outError;

/**
 * Call to complete all on-going session tasks of a background session unless in the excludingSessionTaskIds list
 *
 * @param backgroundSessionId       Id of the background session
 * @param excludingSessionTaskIds   Ids of session tasks to keep
 * @param outError                  error if fail to complete any session tasks
 *
 * @return YES if succeeded, NO if failed to complete any session tasks
 */
- (BOOL)completeOnGoingSessionTasksForBackgroundSessionId:(NSString *)backgroundSessionId
                                  excludingSessionTaskIds:(NSSet *)excludingSessionTaskIds
                                                    error:(NSError **)outError;

/**
 * Check if session task associated with this userId and associateId has completed
 *
 * @param userId            Id of user started the session task. Cannot be nil
 * @param associateId       Id to associate with the session task. Cannot be nil
 *
 * @return YES if completed, NO if not
 */
- (BOOL)isSessionTaskCompletedForUserId:(NSString *)userId associateId:(NSString *)associateId;

/**
 * Clean up on-going session tasks' cached info of backgroundSessionId.
 * This does not clean up info relating to user and completed cached info, which
 * can be done using deleteCachedInfoForUserId:associateId:error
 *
 * @param backgroundSessionId   Id of the background session
 * @param error                 error if fail to complete
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cleanUpOnGoingCachedInfoOfBackgroundSessionId:(NSString *)backgroundSessionId error:(NSError **)error;

/**
 * Clean up users/$userId directory if empty. Expected to be used at logout
 * after cleaning up on user's session tasks
 *
 * @param userId    Id of user
 * @param error     error if fail to complete
 *
 * @return YES if successfully cleaned up users/$userId directory, NO if failed
 */
- (BOOL)cleanUpForUserIdIfEmpty:(NSString *)userId error:(NSError **)error;

/**
 * Get all associateIds with backgroundSessionId and sessionTaskId pairs created by userId
 *
 * @param userId    Id of user started the session tasks. Cannot be nil
 * @param error     error if failed to retrieve
 *
 * @return NSDictionary of associateId to backgroundSessionId and sessionTaskId
 */
- (NSDictionary *)associateIdToBackgroundSessionIdAndSessionTaskIdsForUserId:(NSString *)userId error:(NSError **)error;

/**
 * Get all associateIds used to create session tasks with userId
 *
 * @param userId    Id of user started the session tasks. Cannot be nil
 * @param error     error if failed to retrieve
 *
 * @return array of associateIds used to create session tasks with userId
 */
- (NSArray *)associateIdsForUserId:(NSString *)userId error:(NSError **)error;

/**
 * Cache backgroundSessionId from extension into extensionSessions/$backgroundSessionId file
 *
 * @param backgroundSessionId   Id to cache
 * @param outError                 error if failed to cache
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)cacheBackgroundSessionIdFromExtension:(NSString *)backgroundSessionId error:(NSError **)outError;

/**
 * Return all background session ids known to the app from extensions
 * which were cached previously using cacheBackgroundSessionIdFromExtension:error
 */
- (NSArray *)backgroundSessionIdsFromExtensionsWithError:(NSError **)error;

/**
 * Return resumeData of a completed session task associated with the userId and associateId
 *
 * @param userId        Id of user started the session task. Cannot be nil
 * @param associateId   Id associate with the session task for this user
 *
 * @return resume data for background download task which has completed
 */
- (NSData *)resumeDataForUserId:(NSString *)userId associateId:(NSString *)associateId;

/**
 * Resume a completed download task by deleting its completed dir under users/$userId/$associateId
 *
 * @param userId        Id of user started the session task. Cannot be nil
 * @param associateId   Id associate with the session task for this user
 * @param error         error if failed to resume
 *
 * @return YES if succeeded, NO if failed
 */
- (BOOL)resumeCompletedDownloadSessionTaskForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error;

@end
