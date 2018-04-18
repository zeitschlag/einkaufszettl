//
//  EinkaufszettlTests.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 16.06.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#ifndef Einkaufszettl_EinkaufszettlTests_h
#define Einkaufszettl_EinkaufszettlTests_h


#endif

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

@interface EinkaufszettlTests : XCTestCase

@property NSManagedObjectContext *managedObjectContext;
@property NSManagedObjectModel *managedObjectModel;
@property NSPersistentStore *persistentStore;
@property NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end