//
//  EinkaufszettlTests.m
//  EinkaufszettlTests
//
//  Created by Nathan Mattes on 30.03.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import "EinkaufszettlTests.h"

@implementation EinkaufszettlTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // setup core data stack -> stackoverflow.com/questions/1849802/how-to-unit-test-my-models-now-that-i-am-using-core-data
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Einkaufszettl" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    self.persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                               configuration:nil
                                                                         URL:nil
                                                                     options:nil error:nil];
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    // NSLog(@"model: %@", self.managedObjectModel);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
