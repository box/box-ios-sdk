//
//  BOXStreamOperation.h
//  BoxContentSDK
//
//  Created on 8/5/16.
//  Copyright (c) 2016 Box. All rights reserved.
//

#import "BOXAPIAuthenticatedOperation.h"
#import "BOXAPIDataOperation.h"

// expectedTotalBytes may be NSURLResponseUnknownLength if the operation is unable to determine the
// content-length of the download
typedef void (^BOXAPIStreamProgressBlock)(NSData *data, long long expectedTotalBytes);

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
 */
@interface BOXStreamOperation : BOXAPIAuthenticatedOperation


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
 * Called when the API call successfully receives bytes from the network.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXAPIStreamProgressBlock progressBlock;

/**
 * Call success or failure depending on whether or not an error has occurred during the request.
 * @see successBlock
 * @see failureBlock
 */
- (void)performCompletionCallback;

/**
 * The fileID associated with this download request. This value is passed to progressBlock.
 * @see progressBlock
 */
@property (nonatomic, readwrite, strong) NSString *fileID;

/** @name Overridden methods */

/**
 * BOXAPIDataOperation should only ever be GET requests so there should not be a body.
 *
 * @param bodyDictionary This should always be nil
 * @return nil
 */
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;

/**
 * This method is called with by BOXAPIOperation with the assumption that all
 * data received from the network is buffered. This operation streams all
 * received data to its output stream, so do nothing in this method.
 *
 * @param data This data should be empty.
 */
- (void)processResponseData:(NSData *)data;

@end
