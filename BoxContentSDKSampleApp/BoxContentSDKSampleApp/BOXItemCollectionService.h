//
//  BOXItemCollectionService.h
//  BoxContentSDKSampleApp
//
//  Created by Jim DiZoglio on 7/30/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXItemCollectionService : NSObject

- (BOXRequest *)addItem:(BOXItem *)item
     toCollectionWithID:(NSString *)collectionID
        completionBlock:(BOXItemBlock)completionBlock;

- (BOXRequest *)removeItem:(BOXItem *)item
      fromCollectionWithID:(NSString *)collectionID
           completionBlock:(BOXItemBlock)completionBlock;
@end
