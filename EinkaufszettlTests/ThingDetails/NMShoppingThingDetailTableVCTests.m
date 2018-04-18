//
//  NMShoppingThingDetailTableVCTests.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 27.07.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EinkaufszettlTests.h"
#import "EZLThingDetailTableViewController.h"

@interface NMShoppingThingDetailTableVCTests : EinkaufszettlTests

@property EZLThingDetailTableViewController *viewController;

@end

@implementation NMShoppingThingDetailTableVCTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.viewController = [[EZLThingDetailTableViewController alloc] init];
    self.viewController.managedObjectContext = self.managedObjectContext;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNumberOfRowsInSection
{
//    id tableView = OCMClassMock([UITableView class]);
//    NSInteger section = 0;
//    NSInteger expectation = 2;
//    NSInteger rows = [self.viewController tableView:tableView numberOfRowsInSection:section];
//    XCTAssertEqual(rows, expectation);
//
//    section = 1;
//    expectation = 2;
//    rows = [self.viewController tableView:tableView numberOfRowsInSection:section];
//    XCTAssertEqual(rows, expectation);
//
//    section = 2;
//    expectation = 1;
//    rows = [self.viewController tableView:tableView numberOfRowsInSection:section];
//    XCTAssertEqual(rows, expectation);
//
//
//    section = 3;
//    expectation = 0;
//    rows = [self.viewController tableView:tableView numberOfRowsInSection:section];
//    XCTAssertEqual(rows, expectation);
}

- (void)testNumberOfSectionsInTableView {
    // mock tableView
//    id tableView = OCMClassMock([UITableView class]);
//    NSInteger expectation = [[NSNumber numberWithInt:3] integerValue];
//
//    NSInteger result = [self.viewController numberOfSectionsInTableView:tableView];
//    XCTAssertEqual(result, expectation);
}

// One or two test methods?
- (void)testTitleForHeaderInSections {
//    id tableView = OCMClassMock([UITableView class]);
//    int section = 0;
//
//    section = 1;
//    NSString *expectation = NSLocalizedString(@"quantities", nil);
//    NSString *result = [self.viewController tableView: tableView titleForHeaderInSection:section];
//    XCTAssertEqualObjects(result, expectation);
}

@end
