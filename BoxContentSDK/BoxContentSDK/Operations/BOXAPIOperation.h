//
//  BOXAPIOperation.h
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BOXOAuth2Session.h"

#import "BOXContentSDKConstants.h"

// Success and Failure callbacks
//
// All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
// If you wish to interact with the UI in a callback block, dispatch to the main queue in the
// callback block
//
// These types of callback blocks are used for Box APIs that return JSON
typedef void (^BOXAPIJSONSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary);
typedef void (^BOXAPIJSONFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary);

// These types of callback blocks are used for Box APIs that return binary data, such as downloads
typedef void (^BOXAPIDataSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSData *bodyData);
typedef void (^BOXAPIDataFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSData *bodyData);

/**
 * BOXAPIOpertation is an abstract base class for all Box API call operations. BOXAPIOperation is
 * an NSOperation subclass. Because it is an abstract base class, you should not instantiate it
 * directly. BOXAPIOperation enforces its abstractness with calls to the macro `BOXAbstract` in
 * unimplemented methods. This macro will raise an `NSAssert` when `DEBUG=1`.
 * [BOXAPIOperations](BOXAPIOperation) may be enqueued on an NSOperationQueue using a
 * BOXAPIQueueManager. Subclasses of BOXAPIResourceManager should create instances of BOXAPIOperation
 * to execute API calls.
 *
 * Concrete subclasses of BOXAPIOperation that may be instantiated are:
 *
 * - BOXAPIOAuth2ToJSONOperation
 * - BOXAPIAppAuthOperation
 * - BOXAPIJSONOperation
 * - BOXAPIMultipartToJSONOperation
 * - BOXAPIDataOperation
 *
 * An API call is considered to have succeeded if it returns with an HTTP status code in the
 * 2xx range, with an exception made for 202. 202, 3xx, 4xx, and 5xx are all treated as errors.
 *
 * NSURLConnectionDataDelegate
 * ===========================
 * BOXAPIOperation instances issue API calls using NSURLConnection. Each BOXAPIOperation acts
 * as the delegate for its own API call. [BOXAPIOperations](BOXAPIOperation) are not concurrent
 * NSOperations, so they keep the runloop they are running on open during the lifetime of the
 * request to enable receiving delegate callbacks.
 *
 * By default, a BOXAPIOperation will buffer received data in memory to be proccessed after the connection
 * terminates. See BOXAPIDataOperation for a subclass that does not use this default behavior.
 *
 * Callbacks and typedefs
 * ======================
 * This class declares several block typedefs that are used throughout the SDK. These are:
 *
 * Success and failure callbacks for API calls expecting JSON responses:
 *
 *  <pre><code>typedef void (^BOXAPIJSONSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary);
 * typedef void (^BOXAPIJSONFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary);</code></pre>
 *
 * Success and failure callbacks for API calls expecting binary data responses:
 * 
 * <pre><code>typedef void (^BOXAPIDataSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSData *bodyData);
 * typedef void (^BOXAPIDataFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSData *bodyData);</code></pre>
 *
 *
 * **Note**: All callbacks are triggered on the same thread the BOXAPIOperation runs on. When these operations
 * are enqueued by a BOXAPIQueueManager, they are not executed on the main thread. If you wish to update the UI
 * in a callback, do so inside of a `dispatch_sync` block on the main thread.
 *
 * Subclassing Notes
 * =================
 * Subclasses must override the following abstract methods:
 *
 * - encodeBody:
 * - prepareAPIRequest
 * - processResponseData:
 * - performCompletionCallback
 *
 */
@interface BOXAPIOperation : NSOperation <NSURLConnectionDataDelegate>

/** @name Authorization */

/**
 * The session is used to sign requests with an Authorization header including a Bearer token
 * @see [BOXAbstractSession addAuthorizationParametersToRequest:]
 */
@property (nonatomic, readwrite, weak) BOXAbstractSession *session;

/**
 * The access token this request was made with. This token is used to determine
 * whether this operation failing due to an expired token should cause the tokens to
 * be refreshed.
 */
@property (nonatomic, readwrite, strong) NSString *accessToken;

/** @name Request properties */

/**
 * The canonical URL of the API resource being accessed. This URL does not include query string parameters
 */
@property (nonatomic, readwrite, strong) NSURL *baseRequestURL;

/**
 * Key value pairs to be sent as part of the request body. This body may be encoded in different
 * ways depending on the operation.
 * @see [BOXAPIJSONOperation encodeBody:]
 * @see [BOXAPIMultipartToJSONOperation encodeBody:]
 */
@property (nonatomic, readwrite, strong) NSDictionary *body;

/**
 * Key value pairs to be appended to baseRequestURL as part of the query string. Keys and values
 * will be URL encoded.
 * @see [NSString(BoxURLHelper) stringWithString:URLEncoded:]
 */
@property (nonatomic, readwrite, strong) NSDictionary *queryStringParameters;

/**
 * The API request. This request is signed by the session and is initialized in BOXAPIOperation's
 * designated initializer.
 */
@property (nonatomic, readwrite, strong) NSMutableURLRequest *APIRequest;

/**
 * The URL connection is lazily instantiated when the BOXAPIOperation begins executing.
 */
@property (nonatomic, readwrite, strong) NSURLConnection *connection;

/** @name Request response properties */

/**
 * A buffer that stores incoming data from connection. This data is later processed once the
 * connection has terminated.
 * @see processResponseData:
 */
@property (nonatomic, readwrite, strong) NSMutableData *responseData;

/**
 * The HTTP response. Includes headers and status code. This object is received before any responseData.
 */
@property (nonatomic, readwrite, strong) NSHTTPURLResponse *HTTPResponse;

/** @name Error handling */

/**
 * Stores an error that may occur at one of several phases of the operation lifecycle.
 *
 * This property is used by performCompletionCallback to determine whether to trigger the success or
 * failure callback.
 * @see performCompletionCallback
 */
@property (nonatomic, readwrite, strong) NSError *error;

/**
 * Do not call this. It is used internally.
 */
- (void)finish;

#pragma mark - Initialization
/** @name Initialization */

/**
 * Designated initializer. This initializer sets up APIRequest based on its input parameters
 *
 * @param URL the baseRequestURL
 * @param HTTPMethod one of GET, POST, PUT, DELETE, OPTIONS. Used to configure APIRequest
 * @param body Key value pairs to be encoded as the request body
 * @param queryParams Key value pairs to be encoded as part of the query string
 * @param session used for signing requests
 *
 * @return An initialized BOXAPIOperation
 */
- (id)initWithURL:(NSURL *)URL HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session;

#pragma mark - Accessors
/** @name Accessors */

/**
 * The HTTP method of the API request. One of GET, POST, PUT, DELETE, OPTIONS.
 *
 * This value is part of APIRequest.
 *
 * @return The HTTP method of the API request.
 */
- (BOXAPIHTTPMethod *)HTTPMethod;

#pragma mark - Build NSURLRequest
/**@name Build NSURLRequest */

/**
 * Encode a dictionary representing the body of the request to the appropriate on-the-wire representation.
 * Such representations may include JSON, multipart form data, or form urlencoded data.
 *
 * @param bodyDictionary The NSDictionary to encode.
 *
 * @return An NSData containing the bytes of the encoded representation.
 */
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;

/**
 * Builds the full request URL including the canonical URL and query string parameters
 * @see baseRequestURL
 * @see queryStringParameters
 *
 * @param baseURL The canonical URL of the API request.
 * @param queryDictionary Key value pairs to be encoded as a query string
 *
 * @return A NSURL including query string parameters.
 */
- (NSURL *)requestURLWithURL:(NSURL *)baseURL queryStringParameters:(NSDictionary *)queryDictionary;

#pragma mark - Prepare to make API call
/** @name Prepare to make the API call */

/**
 * Overriding this method allows subclasses to mutate the APIRequest before issuing it.
 *
 * For example, BOXAPIAuthenticatedOperation signs requests with an Authorization header
 */
- (void)prepareAPIRequest;

/**
 * Prepare the BOXAPIOperation to receive delegate callbacks for connection and start connection.
 */
- (void)startURLConnection;

#pragma mark - Process API call results
/** @name Process API call results */

/**
 * Process the received data from the request and create a response that may be used
 * in performCompletionCallback
 *
 * @param data The data received from Box as a result of the API call.
 */
- (void)processResponseData:(NSData *)data;

#pragma mark - callbacks
/** @name Callbacks */

/**
 * Call either a success or failure callback depending on whether or not an error occured during the
 * request.
 */
- (void)performCompletionCallback;

#pragma mark - Lock
/** @name Lock */

/**
 * A global lock to use when enqueuing operations and adding dependencies. This lock ensures that
 * all operation starts and dependency additions are serialized.
 *
 * BOXAPIQueueManagers depend on this serialization to ensure they do not add a BOXAPIOAuth2ToJSONOperation or BOXAPIAppAuthOperation
 * as a dependency to an already-executing or soon-to-be-executing operation.
 *
 * @return A global lock for API operations to use.
 */
+ (NSRecursiveLock *)APIOperationGlobalLock;

@end
