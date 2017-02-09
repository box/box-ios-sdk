//
//  BOXCollection.h
//  BoxContentSDK
//
//  Created on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

/**
 *  Represents a Collection.
 */
@interface BOXCollection : BOXModel

/**
 *  Name of the collection.
 */
@property (nonatomic, readwrite, strong) NSString *name;

/**
 *  The type of the collection. This is used to determine the proper visual treatment for Box-internally created collections. Initially only “favorites” collection-type will be supported.
 */
@property (nonatomic, readwrite, strong) NSString *collectionType;

@end
