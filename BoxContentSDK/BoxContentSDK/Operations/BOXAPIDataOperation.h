//
//  BOXAPIDataOperation.h
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIAuthenticatedOperation.h"

// expectedTotalBytes may be NSURLResponseUnknownLength if the operation is unable to determine the
// content-length of the download
typedef void (^BOXDownloadSuccessBlock)(NSString *modelID, long long expectedTotalBytes);
typedef void (^BOXDownloadFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error);
// expectedTotalBytes may be NSURLResponseUnknownLength if the operation is unable to determine the
// content-length of the download
typedef void (^BOXAPIDataProgressBlock)(long long expectedTotalBytes, unsigned long long bytesReceived);

/**
 * BOXAPIDataOperation is a concrete subclass of BOXAPIAuthenticatedOperation.
 * This operation receives binary data from the Box API which may be in the form
 * of downloads or thumbnails.
 *
 * API calls to Box may fail with a 202 Accepted with an
 * empty body on Downloads of files and thumbnails.
 * This indicates that a file has successfully been uploaded but
 * is not yet available for download or has not yet been converted
 * to the requested thumbnail representation. In these cases, retry
 * after the period of time suggested in the Retry-After header
 *
 * Callbacks and typedefs
 * ======================
 * This class defines a number of block types for use in callback blocks. These are:
 *
 * <pre><code>typedef void (^BOXDownloadSuccessBlock)(NSString *fileID, long long expectedTotalBytes);
 * typedef void (^BOXDownloadFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error);
 * typedef void (^BOXAPIDataProgressBlock)(long long expectedTotalBytes, unsigned long long bytesReceived);</code></pre>
 *
 * **Note**: expectedTotalBytes may be `NSURLResponseUnknownLength` if the operation is unable to
 * determine the Content-Length of the download.
 *
 * @warning Because BOXAPIDataOperation holds references to `NSStream`s, it cannot be copied. Because it
 * cannot be copied, BOXAPIDataOperation instances cannot be automatically retried by the SDK in the event
 * of an expired access token. In this case, the operation will fail with error code
 * `BoxContentSDKAuthErrorAccessTokenExpiredOperationCannotBeReenqueued`.
 *
 * BOXAPIDataOperation supports both foreground and background downloads
 * By default, download is foreground unless associateId and destinationPath properties are provided
 */
@interface BOXAPIDataOperation : BOXAPIAuthenticatedOperation <NSStreamDelegate, BOXURLSessionDownloadTaskDelegate>

/** @name Streams */

/**
 * The output stream to write received bytes to. Received data is immediately written
 * to this output stream if possible. Otherwise it is buffered in memory.
 *
 * All received data from the API call is directed to this output stream. This means
 * that this operation does not processing of data once the connection terminates.
 *
 * **Note**: Creating an output stream to a file can be done easily using `NSOutputStream`:
 *
 * <pre><code>NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];</code></pre>
 *
 * @warning If you are manually reading from this output stream (for example with
 * a `CFStreamCreateBoundPair`) do not let data sit in the stream or you risk causing
 * a large file to buffer entirely in memory.
 *
 * If destinationPath is provided, outputStream will be ignored
 * Using outputStream to consume data will not allow the request to be executed in the background if the app is killed/suspended
 */
@property (nonatomic, readwrite, strong) NSOutputStream *outputStream;

/**
 * The location for output file. If provided, outputStream will be ignored
 * Using destinationPath to consume data will allow request to be executed in the background
 * if the app is killed/suspended and resume upon app restarts/resumes
 * To support background download, make sure associateId is valid as well
 */
@property (nonatomic, readwrite, strong) NSString *destinationPath;

/**
 * This indicates whether background download should be cancelled with intention to resume
 * so we maintain resume information to allow a later operation to resume the download from where it was left off
 */
@property (nonatomic, readwrite, assign) BOOL allowResume;

/** @name Callbacks */

/**
 * Called when the API call completes successfully with a 2xx status code.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXDownloadSuccessBlock successBlock;

/**
 * Called when the API call returns an error with a non-2xx status code.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXDownloadFailureBlock failureBlock;

/**
 * Called when the API call successfully receives bytes from the network connection.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXAPIDataProgressBlock progressBlock;


/**
 * Describes wether or not the operation is a small download such as a thumbnail retrieval.
 * If it is, the operation will be run on a specific queue whose max concurrent operation count will be NSOperationQueueDefaultMaxConcurrentOperationCount
 */
@property (nonatomic, readwrite, assign) BOOL isSmallDownloadOperation;

/**
 * Call success or failure depending on whether or not an error has occurred during the request.
 * @see successBlock
 * @see failureBlock
 */
- (void)performCompletionCallback;

/**
 * When data is successfully received from the network connection,
 * this method is called to trigger progressBlock.
 * @see progressBlock
 */
- (void)performProgressCallback;

/**
 * The fileID associated with this download request. This value is passed to progressBlock.
 * @see progressBlock
 */
@property (nonatomic, readwrite, strong) NSString *modelID;

/** @name Overridden methods */

/**
 * In addition to calling [super]([BOXAPIAuthenticatedOperation prepareAPIRequest]), schedule outputStream
 * in the current run loop and set `outputStream.delegate` to `self`.
 */
- (void)prepareAPIRequest;

/**
 * BOXAPIDataOperation should only ever be GET requests so there should not be a body.
 *
 * @param bodyDictionary This should always be nil
 * @return nil
 */
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;

/**
 * This method is called with by BOXAPIOperation with the assumption that all
 * data received from the network connection is buffered. This operation
 * streams all received data to its output stream, so do nothing in this method.
 *
 * @param data This data should be empty.
 */
- (void)processResponseData:(NSData *)data;

@end
