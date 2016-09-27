//
//  BOXEventsAdminLogsRequest.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXEventsRequest.h>

@interface BOXEventsAdminLogsRequest : BOXEventsRequest

@property (nonatomic, readwrite, strong) NSString *eventType;
@property (nonatomic, readwrite, strong) NSDate *createdAfterDate;
@property (nonatomic, readwrite, strong) NSDate *createdBeforeDate;

@end
