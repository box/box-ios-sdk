//
//  BOXNSURLSessionDelegate.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Class to handle delegate callbacks for NSURLSession
 *
 * FIXME: implement interface NSURLSessionStreamDelegate as well.
 * Note: NSURLSessionStreamDelegate only available on iOS9+
 */
@interface BOXNSURLSessionDelegate : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@end
