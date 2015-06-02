//
//  BOXFileAccessRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileAccessRequest.h"

#import "BOXAPIDataOperation.h"

@interface BOXFileAccessRequest ()

@property (nonatomic, readonly, strong) NSOutputStream *outputStream;

@property (nonatomic, readonly, strong) NSString *destinationPath;

@end

@implementation BOXFileAccessRequest

- (instancetype)initWithFileID:(NSString *)fileID {
    if (self = [super init]) {
        _fileID = fileID;
    }
    return self;
}

- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID;
{
    if (self = [self initWithFileID:fileID]) {
        _destinationPath = destinationPath;
    }
    return self;
}
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID
{
    if (self = [self initWithFileID:fileID]) {
        _outputStream = outputStream;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceContent
                                 subID:nil];

    NSDictionary *queryParameters = nil;

    if (self.versionID.length > 0) {
        queryParameters = @{BOXAPIParameterKeyFileVersion : self.versionID};
    }

    BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                       successBlock:nil
                                                       failureBlock:nil];

    dataOperation.fileID = self.fileID;

    BOXAssert(self.outputStream != nil || self.destinationPath != nil, @"An output stream or destination file path must be specified.");
    BOXAssert(!(self.outputStream != nil && self.destinationPath != nil), @"You cannot specify both an outputStream and a destination file path.");

    if (self.outputStream != nil) {
        dataOperation.outputStream = self.outputStream;
    } else {
        dataOperation.outputStream = [[NSOutputStream alloc] initToFileAtPath:self.destinationPath append:NO];
    }

    [self addSharedLinkHeaderToRequest:dataOperation.APIRequest];

    return dataOperation;
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
