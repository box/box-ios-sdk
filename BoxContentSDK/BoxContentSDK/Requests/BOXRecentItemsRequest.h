//
//  BOXRecentItemsRequest.h
//  Pods
//
//  Created by Andrew Dempsey on 12/19/16.
//
//

#import "BOXRequest.h"

@interface BOXRecentItemsRequest : BOXRequest

/**
 By default, BOXRecentItemsRequest will only fetch a predefined set of fields for the associated
 BOXItem. Use |requestAllItemFields| to request all available fields.
 */
@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

/**
 BOXRecentItemsRequest will fetch the specified metadata for a BOXItem. 
 */
@property (nonatomic,readwrite, copy) NSString *metadataTemplateKey;
@property (nonatomic,readwrite, copy) NSString *metadataScope;

/**
 The list of fields to exclude from the requested BOXItem. This works in conjunction with
 requestAllItemFields to exclude fields from the list of all item fields.
 
 If requestAllItemFields is NO, fieldsToExclude will not have any effect, and the
 response will include default fields from the API.
 */
@property (nonatomic, readwrite, strong) NSArray<NSString *> *fieldsToExclude;

/**
 Number of records to fetch. 
 - Minimum allowed value: 0
 - Maximum allowed value: 1000
 - Defaults to 100 (at time of writing)
 */
@property (nonatomic, readwrite, assign) NSInteger limit;

/**
 Marker of the recents record to begin the listing. Use this field when making multiple paged requests.
 For example, after requesting the first 100 records, you can provide the nextMarker to fetch another set of
 records beginning at the 101st item in the listing. The next available marker ID is returned in the response header
 of each paged recent items request.
 */
@property (nonatomic, readwrite, strong) NSString *nextMarker;

/**
 Selects which filter should be applied to the recent items list.
 Possible values are:
 - BOXAPIRecentItemsListTypeShared (will return only items recently accessed through a shared link)
 - Defaults to no filter
 */
@property (nonatomic, readwrite, strong) NSString *listType;

//Perform API request and any cache update only if completionBlock is not nil
- (void)performRequestWithCompletion:(BOXRecentItemsBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXRecentItemsBlock)cacheBlock
                       refreshed:(BOXRecentItemsBlock)refreshBlock;

@end
