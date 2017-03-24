//
//  Header.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 3/23/17.
//  Copyright © 2017 Box. All rights reserved.
//

@interface BOXURLSessionManager()

// Initialize with additional protocol classes that handle requests in internal NSURLSessions of BOXURLSessionManager
// Currently used by test cases to control the expected responses/data for API requests without reaching the server
- (_Nullable id)initWithProtocolClasses:(NSArray * _Nullable)protocolClasses;

@end
