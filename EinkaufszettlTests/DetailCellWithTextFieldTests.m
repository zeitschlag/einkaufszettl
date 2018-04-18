////
////  DetailCellWithTextFieldTests.m
////  Einkaufszettl
////
////  Created by Nathan Mattes on 28.07.15.
////  Copyright (c) 2015 Nathan Mattes. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
//#import "EinkaufszettlTests.h"
//
//#import "DetailCellWithTextField.h"
//#import "Einkaufszettl-Swift.h"
//
//@interface DetailCellWithTextFieldTests : EinkaufszettlTests
//
//@property DetailCellWithTextField *detailCellWithTextField;
//
//@end
//
//@implementation DetailCellWithTextFieldTests
//
//@synthesize detailCellWithTextField;
//
//- (void)setUp
//{
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//    detailCellWithTextField = [[DetailCellWithTextField alloc] init];
//}
//
//- (void)tearDown
//{
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//// TODO Refactor this test! Use OCMock like in the commits before instead of UITextFields? Change Method?
//- (void)testShouldChangeInRangeWithNonNumericTextField {
//    // Mock stuff, set expectation and shit
//    BOOL expected = YES;
//    BOOL result;
//    UITextField *textField = [[UITextField alloc] init];
//    textField.text = @"";
//    NSRange range = NSRangeFromString(@"");
//    NSString *string = @"";
//    
//    detailCellWithTextField.decimalNumeric = NO;
//    result = [detailCellWithTextField textField:textField shouldChangeCharactersInRange:range replacementString:string];
//    XCTAssertEqual(result, expected);
//    XCTAssertEqualObjects(string, textField.text);
//    
//}
//
//- (void)testShouldChangeInRangeWithLettersAsReplacementString {
//    BOOL expected = NO;
//    BOOL result;
//    UITextField *textField = [[UITextField alloc] init];
//    textField.text = @"0";
//    
//    NSRange range = NSRangeFromString(@"");
//    NSString *string = @"abc";
//    NSString *expectedText = @"0";
//    detailCellWithTextField.decimalNumeric = YES;
//
//    result = [detailCellWithTextField textField:textField shouldChangeCharactersInRange:range replacementString:string];
//    XCTAssertEqual(result, expected);
//    XCTAssertEqualObjects(expectedText, textField.text);
//    
//}
//
//- (void)testShouldChangeInRangeWithSeperatorOnly
//{
//    BOOL expected = NO;
//    BOOL result;
//    NSString *seperatorString = [[[NSNumberFormatter alloc] init] decimalSeparator];
//    NSString *expectedText = [NSString stringWithFormat:@"0%@", seperatorString];
//    UITextField *textField = [[UITextField alloc] init];
//    textField.text = @"";
//    NSRange range = NSRangeFromString(@"");
//    detailCellWithTextField.decimalNumeric = YES;
//    
//    result = [detailCellWithTextField textField:textField shouldChangeCharactersInRange:range replacementString:seperatorString];
//    XCTAssertEqual(result, expected);
//    XCTAssertEqualObjects(textField.text, expectedText);
//    
//}
//
//- (void)testShouldChangeInRangeWithSeperator
//{
//    BOOL expected = NO;
//    BOOL result;
//    UITextField *textField = [[UITextField alloc] init];
//    NSString *seperatorString = [[[NSNumberFormatter alloc] init] decimalSeparator];
//
//    textField.text = seperatorString;
//    NSRange range = NSRangeFromString(@"");
//    // string = seperatorString // not necessary, cause string's still seperatorString
//    detailCellWithTextField.decimalNumeric = YES;
//    result = [detailCellWithTextField textField:textField shouldChangeCharactersInRange:range replacementString:seperatorString];
//    XCTAssertEqual(result, expected);
//    XCTAssertEqualObjects(seperatorString, [textField text]);
//}
//
//- (void)testShouldChangeInRangeWithNumber
//{
//    BOOL expected = NO;
//    BOOL result;
//    // id textField = OCMClassMock([UITextField class]);
//    UITextField *textField = [[UITextField alloc] init];
//    textField.text = @"0";
//    NSRange range = NSRangeFromString(@"");
//    detailCellWithTextField.decimalNumeric = YES;
//    
//    OCMStub([textField text]).andReturn(@"0");
//    NSString *string = @"1";
//    result = [detailCellWithTextField textField:textField shouldChangeCharactersInRange:range replacementString:string];
//    XCTAssertEqual(result, expected);
//    XCTAssertEqualObjects(string, [textField text]);
//}
//
//-(void)testTextFieldShouldReturn
//{
//    BOOL expected = YES;
//    BOOL result;
//    UITextField *textField = [[UITextField alloc] init];
//    result = [detailCellWithTextField textFieldShouldReturn:textField];
//    
//    XCTAssertEqual(expected, result);
//}
//
//@end
