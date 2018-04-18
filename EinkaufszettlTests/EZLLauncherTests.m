//
//  EZLLauncherTests.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 11.07.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EinkaufszettlTests.h"
#import "EZLLauncher.h"

@interface EZLLauncher (EZLLauncherPrivate)
- (BOOL)getDefaultThingsFromPath:(NSString *)path;
- (BOOL)getDefaultUnitsFromPath:(NSString *)path;
@end

@interface EZLLauncherTests : EinkaufszettlTests

@property EZLLauncher* launcher;

@end

@implementation EZLLauncherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.launcher = [[EZLLauncher alloc] init];
    self.launcher.language = @"en";
    self.launcher.managedObjectContext = self.managedObjectContext;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetDefaultUnitsFromPath {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"units-en" ofType:@"json"];
    BOOL expected = YES;
    BOOL result = [self.launcher getDefaultUnitsFromPath:path];
    XCTAssertEqual(expected, result);

    path = [[NSBundle mainBundle] pathForResource:@"fails" ofType:@"json"];
    expected = NO;
    result = [self.launcher getDefaultUnitsFromPath:path];
    XCTAssertEqual(expected, result);
}

- (void)testGetDefaultThingsFromPath {
    NSString *unitPath = [[NSBundle mainBundle] pathForResource:@"units-en" ofType:@"json"];
    NSString *thingPath = [[NSBundle mainBundle] pathForResource:@"things-en" ofType:@"json"];
    [self.launcher getDefaultUnitsFromPath:unitPath];

    BOOL expected = YES;
    BOOL result = [self.launcher getDefaultUnitsFromPath:thingPath];
    XCTAssertEqual(expected, result);

    thingPath = [[NSBundle mainBundle] pathForResource:@"fails" ofType:@"json"];
    expected = NO;
    result = [self.launcher getDefaultUnitsFromPath:thingPath];
    XCTAssertEqual(expected, result);
}


@end
