//
//  BOXStreamingHashHelper.h
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 5/21/18.
//  Copyright © 2018 Box. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@protocol BOXStreamingDataProcessor
- (void)open;
- (void)processData:(NSData*) data;
/*!
 * @brief Close the stream and return the result of the operation
 */
- (NSString *)close;
@end

@interface BOXStreamingHashHelper : NSObject <BOXStreamingDataProcessor>
@end
NS_ASSUME_NONNULL_END
