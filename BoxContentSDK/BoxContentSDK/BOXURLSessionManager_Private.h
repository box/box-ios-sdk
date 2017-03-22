//
//  Header.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 3/23/17.
//  Copyright © 2017 Box. All rights reserved.
//

@interface BOXURLSessionManager()

// Initialize with additional protocol classes when setting up configurations for internal NSURLSessions of BOXURLSessionManager
// Currently, to be used by test cases
- (_Nullable id)initWithProtocolClasses:(NSArray * _Nullable)protocolClasses;

@end
