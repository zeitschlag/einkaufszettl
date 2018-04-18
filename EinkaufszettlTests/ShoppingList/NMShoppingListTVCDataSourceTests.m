////
////  NMShoppingListTVCDataSourceTests.m
////  Einkaufszettl
////
////  Created by Nathan Mattes on 12.10.15.
////  Copyright © 2015 Nathan Mattes. All rights reserved.
////
//
//#import <XCTest/XCTest.h>
//#import "EinkaufszettlTests.h"
//#import <MGSwipeTableCell/MGSwipeTableCell.h>
//
//#import "EZLShoppingListDataSource.h"
//
///*
// Declare a Category to access private methods
// category: http://code.tutsplus.com/tutorials/objective-c-categories--mobile-10648
// hint: http://stackoverflow.com/a/1099281
//*/
//@interface EZLShoppingListDataSource (NMShoppingListTVCDataSourcePrivate)
//- (void)configureCell:(MGSwipeTableCell *)cell WithThing:(Thing *)thing;
//- (NSString *)detailTextForThing:(Thing *)thing;
//@end
//
//@interface NMShoppingListTVCDataSourceTests : EinkaufszettlTests
//
//@property EZLShoppingListDataSource *dataSource;
//
//@end
//
//@implementation NMShoppingListTVCDataSourceTests
//
//- (void)setUp
//{
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//    self.dataSource = [[EZLShoppingListDataSource alloc] init];
//    self.dataSource.tintColor = [UIColor redColor];
//}
//
//- (void)tearDown
//{
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//-(void)testConfigureCell
//{
//    // Mock these things
//    MGSwipeTableCell *cell = [[MGSwipeTableCell alloc] init];
//    Thing *thing = [Thing initWithManagedObjectContext:self.managedObjectContext withName:@"Test"];
//    
//    [thing setBought:[NSNumber numberWithBool:YES]];
//    [thing setOnList:[NSNumber numberWithBool:YES]];
//    
//    // Test: Strikethrough
//    NSMutableAttributedString *textLabelString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",thing.name]];
//    [textLabelString addAttribute:NSStrikethroughStyleAttributeName
//                            value:[NSNumber numberWithInt:2]
//                            range:NSMakeRange(0, thing.name.length)];
//    [textLabelString addAttribute:NSStrikethroughColorAttributeName
//                            value:self.dataSource.tintColor
//                            range:NSMakeRange(0, thing.name.length)];    [self.managedObjectContext save:nil];
//    
//    [self.dataSource configureCell:cell WithThing:thing];
//    XCTAssertEqualObjects(textLabelString, cell.textLabel.attributedText);
//    
//    [thing setBought:[NSNumber numberWithBool:NO]];
//    
//    [self.dataSource configureCell:cell WithThing:thing];
//    textLabelString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",thing.name]];
//    XCTAssertEqualObjects(textLabelString, cell.textLabel.attributedText);
//}
//
//-(void)testDetailTextForThing {
//    NSString *expected = @" ";
//    Thing *thing = [Thing initWithManagedObjectContext:self.managedObjectContext withName:@"Test"];
//    Unit *unit = (Unit *)[NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
//    [unit setName:@"Unit"];
//    
//    [thing setAmount:[NSNumber numberWithInt:0]];
//    XCTAssertEqualObjects(expected, [self.dataSource detailTextForThing:thing]);
//    [thing setAmount:[NSNumber numberWithInt:1]];
//    expected = @"1";
//    XCTAssertEqualObjects(expected, [self.dataSource detailTextForThing:thing]);
//    
//    [thing setUnit:unit];
//    expected = @"1 Unit";
//    XCTAssertEqualObjects(expected, [self.dataSource detailTextForThing:thing]);
//}
//
//@end
