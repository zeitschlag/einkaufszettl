//
//  NMAddThingsToListTableVCTests.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 27.07.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EinkaufszettlTests.h"

@interface NMAddThingsToListTableVCTests : EinkaufszettlTests

//@property EZLAddThingsTableViewController *viewController;
//@property NSString *testThingName;

@end

@implementation NMAddThingsToListTableVCTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    self.testThingName = @"Testthing";
//    self.viewController = [[EZLAddThingsTableViewController alloc] init];
//    self.viewController.managedObjectContext = self.managedObjectContext;
//    self.viewController.searchController = [[EZLSearchController alloc] init];
//    self.viewController.searchController.searchBar.text = self.testThingName;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

#if 0
- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
#endif

- (void)testCreateNewThing
{
    // Mock SearchBar
//    Product *testThing = [Thing initWithManagedObjectContext:self.managedObjectContext withName:self.testThingName];
//    testThing.onList = [NSNumber numberWithBool:YES];
//    testThing.bought = [NSNumber numberWithBool:NO];
//    testThing.amount = [NSNumber numberWithInt:0];
//    [[self managedObjectContext] save:nil];
//    [self.viewController createNewThingWithName:self.testThingName withAmount:[NSNumber numberWithInt:0] onList:YES bought:NO];
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
//    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    
//    // TODO: This Unit Test fails, I don't know why. See the debug-output below. The only thing, which is different, seems to be the ID, so it
//    /*
//     <Thing: 0x1702a3960> (entity: Thing; id: 0x170222560 <x-coredata://4EDE3DBC-193E-4711-83CB-FF33487FA8C0/Thing/p1> ; data: {
//     amount = 0;
//     bought = 0;
//     name = Testthing;
//     onList = 1;
//     unit = nil;
//     })
//     
//     (lldb) po results.lastObject
//     <Thing: 0x1702a39c0> (entity: Thing; id: 0x170033c20 <x-coredata://4EDE3DBC-193E-4711-83CB-FF33487FA8C0/Thing/p2> ; data: {
//     amount = 0;
//     bought = 0;
//     name = Testthing;
//     onList = 1;
//     unit = nil;
//     })
//     */
//    // XCTAssertEqualObjects(testThing, [results lastObject]);
//    Thing *resultThing = (Thing *)results.lastObject;
//    
//    XCTAssertEqualObjects(testThing.name, resultThing.name);
//    XCTAssertEqualObjects(testThing.amount, resultThing.amount);
//    XCTAssertEqualObjects(testThing.onList, resultThing.onList);
//    XCTAssertEqualObjects(testThing.unit, resultThing.unit);
//    XCTAssertEqualObjects(testThing.bought, resultThing.bought);
}

- (void)testToggleOnListToFalseOfThing
{
//    NSNumber *expectation = [NSNumber numberWithBool:NO];
//    Thing *testThing = [Thing initWithManagedObjectContext:self.managedObjectContext withName:self.testThingName];
//    testThing.onList = [NSNumber numberWithBool:YES];
//    [self.managedObjectContext save:nil];
//    [self.viewController toggleOnListOfThing:testThing];
//    XCTAssertEqualObjects(testThing.onList, expectation);
}

- (void)testToggleOnListToTrueOfThing
{
//    NSNumber *expectation = [NSNumber numberWithBool:YES];
//    Thing *testThing = [Thing initWithManagedObjectContext:self.managedObjectContext withName:self.testThingName];
//    testThing.onList = [NSNumber numberWithBool:NO];
//    [self.managedObjectContext save:nil];
//    [self.viewController toggleOnListOfThing:testThing];
//    XCTAssertEqualObjects(testThing.onList, expectation);
}

- (void)testNumbersOfSectionsInTableView {
//    id tableView = OCMClassMock([UITableView class]);
//    id resultsController = OCMClassMock([NSFetchedResultsController class]);
//    
//    NSArray *array = @[@"1", @"2", @"3"];
//    NSInteger expectation = [array count];
//    
//    OCMStub([resultsController sections]).andReturn(array);
//    self.viewController.resultsController = resultsController;
//    
//    NSInteger result = [self.viewController numberOfSectionsInTableView:tableView];
//    XCTAssertEqual(result, expectation);
}

- (void)testTableViewHeightForCellAtIndexPath
{
//    id indexPath = OCMClassMock([NSIndexPath class]);
//    id tableView = OCMClassMock([UITableView class]);
//    CGFloat expectation = 60.0;
//    CGFloat result = [self.viewController tableView:tableView heightForRowAtIndexPath:indexPath];
//    XCTAssertEqual(result, expectation);    
}

@end
