//
//  BOXEventsRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

typedef NS_ENUM(NSUInteger, BOXEventsStreamType) {
    BOXEventsStreamTypeAll = 0,
    BOXEventsStreamTypeChanges,
    BOXEventsStreamTypeSync
};

@interface BOXEventsRequest : BOXRequest

@property (nonatomic, readwrite, strong) NSString *streamPosition;
@property (nonatomic, readwrite, assign) BOXEventsStreamType streamType;
@property (nonatomic, readwrite, assign) NSInteger limit;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXEventsBlock)completionBlock;

@end
