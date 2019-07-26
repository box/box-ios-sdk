//
//  BOXRequest+Metadata.h
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequest.h"

@interface BOXRequest (Metadata)

- (NSURL *)URLWithResource:(NSString *)resource
                        ID:(NSString *)ID
               subresource:(NSString *)subresource
                     scope:(NSString *)scope
                  template:(NSString *)templateName;

- (NSURL *)URLWithBaseURL:(NSString *)baseURL
                 resource:(NSString *)resource
                       ID:(NSString *)ID
              subresource:(NSString *)subresource
                    scope:(NSString *)scope
                 template:(NSString *)templateName;

@end
