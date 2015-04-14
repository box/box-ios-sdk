//
//  BOXCollectionTests.m
//  BoxContentSDK
//
//  Created on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXCollection.h"

@interface BOXCollectionTests : BOXModelTestCase    

@end

@implementation BOXCollectionTests 


- (void)test_collection_is_correctly_parsed
{
    NSDictionary *dict = [self dictionaryFromCannedJSON:@"collection_all_fields"];
    BOXCollection *collection = [[BOXCollection alloc] initWithJSON:dict];
    
    XCTAssertEqualObjects(collection.modelID, @"5880");
    XCTAssertEqualObjects(collection.type, BOXAPIItemTypeCollection);
    XCTAssertEqualObjects(collection.name, @"Favorites");
    XCTAssertEqualObjects(collection.collectionType, @"favorites");
}



@end
