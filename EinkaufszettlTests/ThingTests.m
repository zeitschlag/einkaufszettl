////
////  ThingTests.m
////  Einkaufszettl
////
////  Created by Nathan Mattes on 16.06.15.
////  Copyright (c) 2015 Nathan Mattes. All rights reserved.
////
//
//#import "EinkaufszettlTests.h"
//#import "Product+CoreDataClass.h"
//#import "ProductCategory+CoreDataClass.h"
//
//@interface ThingTests : EinkaufszettlTests
//
//@end
//
//
//@implementation ThingTests
//
//-(void)setUp {
//    [super setUp];
//}
//
//-(void)tearDown {
//    [super tearDown];
//}
//
//-(void)testInsertNewThingWithName {
//    
//    NSString *testName = @"Testname";
//    Product *product = [Product initWithManagedObjectContext:self.managedObjectContext
//                                                    withName:testName];
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
//    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest
//                                                                error:nil];
//    
//    XCTAssertEqual(product, [results lastObject]);
//}
//
//-(void)testCategoryNameWithoutCategory {
//    NSString *expected = NSLocalizedString(@"no_category", nil);
//    NSString *testName = @"Testname";
//    Product *product = [Product initWithManagedObjectContext:self.managedObjectContext
//                                                    withName:testName];
//    
//    XCTAssertEqual([product categoryName], expected);
//}
//
//-(void)testCategoryNameWithCategory {
//    NSString *expected = @"Category Name";
//    NSString *testName = @"Testname";
//    Product *product = [Product initWithManagedObjectContext:self.managedObjectContext
//                                                    withName:testName];
//    ProductCategory *category = [ProductCategory initWithManagedObjectContext:self.managedObjectContext
//                                                                     withName:expected];
//    product.category = category;
//    
//    XCTAssertEqual([product categoryName], expected);
//}
//
//
//
//
//@end
