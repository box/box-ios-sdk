//
//  BOXAPIMultipartToJSONOperation.h
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIJSONOperation.h"

typedef void (^BOXAPIMultipartProgressBlock)(unsigned long long totalBytes, unsigned long long bytesSent);

/**
 * BOXAPIMultipartToJSONOperation is an authenticated API operation that sends data
 * encoded as multipart form data and receives a JSON response. This operation is used
 * for uploading files to the Box API. Multipart data is streamed to the Box API, which
 * allows large files to be uploaded directly from disk without running out of memory.
 *
 * The implementation of this class is based on [RFC 1876](http://tools.ietf.org/rfc/rfc1867.txt).
 *
 * Each section of the multipart form data is encapsulated as a single piece. Body data passed in through
 * the designated initializer is converted to multipart pieces. You may append arbitrary data as multipart pieces.
 * Each piece is isolated from others in the request using multipart form boundaries.
 *
 * Callbacks and typedefs
 * ======================
 * This operation defines a new callback type for upload progress callbacks:
 *
 * <pre><code>typedef void (^BOXAPIMultipartProgressBlock)(unsigned long long totalBytes, unsigned long long bytesSent);</code></pre>
 *
 * @warning Because BOXAPIMultipartToJSONOperation holds references to `NSStream`s, it cannot be copied. Because it
 * cannot be copied, BOXAPIMultipartToJSONOperation instances cannot be automatically retried by the SDK in the event
 * of an expired access token. In this case, the operation will fail with error code
 * `BoxContentSDKAuthErrorAccessTokenExpiredOperationCannotBeReenqueued`.
 */
@interface BOXAPIMultipartToJSONOperation : BOXAPIJSONOperation <NSStreamDelegate>

/** @name Callbacks */

/**
 * progressBlock is called every time data is successfully written [self.connection]([BOXAPIOperation connection])'s
 * HTTPBodyStream.
 */
@property (nonatomic, readwrite, strong) BOXAPIMultipartProgressBlock progressBlock;

/**
 * When data is successfully written to [self.connection]([BOXAPIOperation connection])'s input stream,
 * this method is called to trigger progressBlock.
 * @see progressBlock
 */
- (void)performProgressCallback;

/** @name Multipart data handling */

/**
 * The length in bytes of the complete multipart form data encoded body.
 */
- (unsigned long long)contentLength;

/**
 * Append the contents of data as a multipart piece in the multipart form data. Data will be
 * attached with a Content-Disposition header derived from fieldName and filename.
 *
 * @param data The data to include in the body of this multipart piece.
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (void)appendMultipartPieceWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/**
 * Append the contents of inputStream as a multipart piece in the multipart form data. Data will be
 * attached with a Content-Disposition header derived from fieldName and filename.
 *
 * The inputStream is never buffered. It is read incrementally and immediately streamed to this
 * operation's NSURLConnection.
 *
 * @param inputStream A stream containing the data to include in the body of this multipart piece.
 * @param length The length in bytes of the data backing inputStream. This parameter is required
 *   to correctly compute contentLength. If this value is incorrect, the multipart form data may be truncated.
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (void)appendMultipartPieceWithInputStream:(NSInputStream *)inputStream contentLength:(unsigned long long)length fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/**
 * Initialize the streams used for writing to the connection's input stream, finalize the HTTP headers
 * for the request, notably Content-Length, and set the connection's HTTPBodyStream.
 *
 * @see [BOXAPIAuthenticatedOperation prepareAPIRequest]
 */
- (void)prepareAPIRequest;

/** @name Overridden methods */

/**
 * Override this method to turn it into a NO-OP. The multipart operation will attach itself
 * to the request with a stream
 *
 * @param bodyDictionary This dictionary should already be attached to the request as a multipart piece
 *
 * @return nil
 */
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;

@end

#pragma mark - Multipart Form pieces

typedef enum {
    BOXAPIMultipartPieceStateNotOpen = 0,
    BOXAPIMultipartPieceStateInitialBoundary,
    BOXAPIMultipartPieceStateHeaders,
    BOXAPIMultipartPieceStateBodyData,
    BOXAPIMultipartPieceStateFinalBoundary,
    BOXAPIMultipartPieceStateClosed,
} BOXAPIMultipartPieceState;

/**
 * This class encapsulates one multipart form parameter. It provides one
 * interface to extract the data associated with this multipart piece that
 * will ouput raw bytes from the underlying components that make up the piece.
 * All components are represented as sreams. Components that are not streams
 * are converted to streams.
 *
 * These components are:
 *
 * - A form boundary (either initial or encapsulation)
 * - Headers included in the multipart piece (i.e.: Content-Type, Content-Disposition)
 * - The body data associated with this piece
 * - An optional final form boundary
 *
 * Clients of this class are expected to configure these components through the given
 * properties before reading from the underlying components.
 *
 * Reading data from an instance of this class is implemented as a state machine.
 * Reading from each component is represented as a distinct state. The read method
 * will only read data from one component during a single invocation.
 *
 * The states are:
 * - not open
 * - initial boundary
 * - headers
 * - body data
 * - final boundary
 * - closed
 *
 * @warning This class is used internally by BOXAPIMultipartTOJSONOperation
 * to implement [RFC 1876](http://tools.ietf.org/rfc/rfc1867.txt) compliant uploads.
 *
 * @warning This class presents an interface like an NSOutputStream, but it differs in several
 * key ways.
 */
@interface BOXAPIMultipartPiece : NSObject

/** @name State */

/**
 * Headers associated with the multipart piece. These include Content-Disposition,
 * Content-Length, and Content-Type.
 */
@property (nonatomic, readwrite, strong) NSMutableDictionary *headers;

/**
 * An input stream generated from encoding headers.
 */
@property (nonatomic, readwrite, strong) NSInputStream *headersInputStream;

/**
 * An input stream for the body of the piece.
 */
@property (nonatomic, readonly) NSInputStream *bodyInputStream;

/**
 * The length of the data in bodyInputStream.
 */
@property (nonatomic, readwrite, assign) unsigned long long bodyContentLength;

/**
 * Whether this piece is the first piece in the request. Consumers of this class
 * should set this property to `YES` on the first instance of this class
 * written to a connection's input stream.
 *
 * This property determines whether startBoundaryInputStream is an encapsulation
 * boundary or an initial boundary.
 */
@property (nonatomic, readwrite, assign) BOOL hasInitialBoundary;

/**
 * An input stream generated from the first boundary of this piece. This boundary
 * may either be an initial boundary or an encapsulation boundary.
 */
@property (nonatomic, readwrite, strong) NSInputStream *startBoundaryInputStream;

/**
 * Whether this piece is the last piece in the request. Consumers of this class
 * should set this property to `YES` on the last instance of this class
 * written to a connection's input stream.
 *
 * This property determines whether endBoundaryInputStream is empty or
 * a final boundary.
 */
@property (nonatomic, readwrite, assign) BOOL hasFinalBoundary;

/**
 * An input stream generated from the end boundary of this piece. This boundary
 * may either be empty or a final boundary.
 */
@property (nonatomic, readwrite, strong) NSInputStream *endBoundaryInputStream;

/**
 * Encapsulates the current input stream this piece is reading from.
 */
@property (nonatomic, readwrite, assign) BOXAPIMultipartPieceState state;

/** @name Initializers */

/**
 * Initialize a multipart piece with data as the body data
 *
 * @param data The data to be sent as the body of this multipart piece
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 */
- (id)initWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename;

/**
 * Initialize a multipart piece with data as the body data
 *
 * @param data The data to be sent as the body of this multipart piece
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (id)initWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/**
 * Initialize a multipart piece with inputStream as the body data
 *
 * @param inputStream A stream containing the data to be sent as the body of this multipart piece
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 */
- (id)initWithInputStream:(NSInputStream *)inputStream fieldName:(NSString *)fieldName filename:(NSString *)filename;

/**
 * Initialize a multipart piece with inputStream as the body data
 *
 * @param inputStream A stream containing the data to be sent as the body of this multipart piece
 * @param fieldName The value of the name component of the Content-Disposition header for this piece.
 * @param filename If this piece is a file, the value of the filename parameter of the Content-Disposition
 *   header for this piece. filename should only be provided if this piece represents a file upload. Pass nil
 *   otherwise.
 * @param MIMEType The MIME type of the provided data. This value will be included in this piece's Content-Type
 *   header. MIMEType is optional. Pass nil if you do not wish to provide it.
 */
- (id)initWithInputStream:(NSInputStream *)inputStream fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/** @name Piece data */

/**
 * The length in bytes of all components of this piece.
 *
 * @return The length in bytes of all components of this piece.
 */
- (unsigned long long)contentLength;

/**
 * The bytes representing the start boundary of this piece. This may be an encapsulation
 * boundary or an initial boundary.
 *
 * @see hasInitialBoundary
 *
 * @return The bytes representing the start boundary of this piece.
 */
- (NSData *)startBoundaryData;

/**
 * The bytes representing the end boundary of this piece. This may be empty
 * or a final boundary.
 *
 * @see hasFinalBoundary
 *
 * @return The bytes representing the end boundary of this piece.
 */
- (NSData *)endBoundaryData;

/**
 * The bytes representing the headers of this multipart piece.
 *
 * @return The bytes representing the headers of this multipart piece.
 */
- (NSData *)headersData;

/** @name Stream interaction */

/**
 * This method is the main interface of this class. It reads from the streams of the
 * underlying piece components and places read bytes into outputData.
 *
 * This method returns -1 on failure to read from any of its underlying streams.
 *
 * @warning Unlike an NSInputStream, this method may return 0, yet still have data left to
 * read. This occurs whenever the multipart piece is switching between its component
 * input streams. To determine whether a piece has data left to read, use hasBytesAvailable.
 *
 * @see hasBytesAvailable
 *
 * @warning Neither outputData nor *outputData may be nil. If either are nil, an assertion
 * failure will be raised.
 *
 * @param outputData Data read from the underlying streams will be written into outputData's byte array
 * @param length The maximum amount of data to read into outputData
 * @param error an NSError pointer to be populated with a stream error if any. error will be populated if
 *   this method returns `-1`.
 *
 * @return The number of bytes written to outputData, or -1 on a stream error.
 */
- (NSInteger)read:(NSMutableData **)outputData maxLength:(NSUInteger)length error:(NSError **)error;

/**
 * Create the streams of the underlying components for reading.
 *
 * This method should be called on the state transition from `BOXAPIMultipartPieceStateNotOpen`
 * to `BOXAPIMultipartPieceStateInitialBoundary`.
 */
- (void)initializeInputStreams;

/**
 * Close the current stream and open the next one for reading.
 *
 * This method should be called when the input stream of one component reaches its end.
 */
- (void)transitionToNextState;

/**
 * Whether the multipart piece still has data left to read. This method returns true as long
 * as state is not `BOXAPIMultipartPieceStateClosed`
 */
- (BOOL)hasBytesAvailable;

/**
 * Closes all underlying component streams and advances state to `BOXAPIMultipartPieceStateClosed`.
 */
- (void)close;

@end