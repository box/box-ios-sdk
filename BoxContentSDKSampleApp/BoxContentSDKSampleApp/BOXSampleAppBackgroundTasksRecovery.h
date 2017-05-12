//
//  BOXSampleAppBackgroundTasksRecovery.h
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 5/12/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXSampleAppBackgroundTasksRecovery : NSObject

+ (void)reconnectBackgroundTasks:(BOXContentClient *)client;

@end
