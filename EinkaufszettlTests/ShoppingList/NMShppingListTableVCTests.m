//
//  NMShppingListTableVCTests.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.07.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EinkaufszettlTests.h"

@interface NMShppingListTableVCTests : EinkaufszettlTests

//@property EZLShoppingListTableViewController *viewController;
//@property Product *thing;

@end

@implementation NMShppingListTableVCTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    self.viewController = [[EZLShoppingListTableViewController alloc] init];
//    self.viewController.managedObjectContext = self.managedObjectContext;
//    self.thing = [Thing initWithManagedObjectContext:self.managedObjectContext withName:@"Testthing"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*- (void)testToggleBought {
    NSNumber *expected = [NSNumber numberWithBool:YES];
    thing.bought = [NSNumber numberWithBool:NO];
    [self.viewController toggleBought:thing];
    XCTAssertEqualObjects(thing.bought, expected);
}*/

@end
