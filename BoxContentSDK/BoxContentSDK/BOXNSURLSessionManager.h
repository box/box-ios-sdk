//
//  BOXNSURLSessionManager.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXNSURLSessionManager : NSObject

- (NSURLSessionDataTask *)createDataTask:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler;

- (NSURLSessionDataTask *)createLoginDataTask:(NSURL *)url;

- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request;

- (NSURLSessionDownloadTask *)createDownloadTaskWithResumeData:(NSData *)resumeData;

- (NSURLSessionUploadTask *)createUploadTask:(NSURLRequest *)request fromFile:(NSURL *)fileURL;

@end
