/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import "FBApplication.h"
#import "FBIntegrationTestCase.h"
#import "FBTestMacros.h"
#import "FBSpringboardApplication.h"
#import "XCUIApplication+FBHelpers.h"
#import "XCUIElement+FBIsVisible.h"

@interface XCUIApplicationHelperTests : FBIntegrationTestCase
@end

@implementation XCUIApplicationHelperTests

- (void)testQueringSpringboard
{
  [self goToSpringBoard];
  XCTAssertTrue([FBSpringboardApplication fb_springboard].icons[@"Safari"].exists);
  XCTAssertTrue([FBSpringboardApplication fb_springboard].icons[@"Game Center"].exists);
}

- (void)testTappingAppOnSpringboard
{
  [self goToSpringBoard];
  NSError *error;
  XCTAssertTrue([[FBSpringboardApplication fb_springboard] fb_tapApplicationWithIdentifier:@"Safari" error:&error]);
  XCTAssertNil(error);
  FBAssertWaitTillBecomesTrue([FBApplication fb_activeApplication].buttons[@"URL"].exists);
}

- (void)testWaitingForSpringboard
{
  NSError *error;
  [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonHome];
  XCTAssertTrue([[FBSpringboardApplication fb_springboard] fb_waitUntilApplicationBoardIsVisible:&error]);
  XCTAssertNil(error);
  XCTAssertTrue([FBSpringboardApplication fb_springboard].icons[@"Safari"].fb_isVisible);
}

- (void)testApplicationTree
{
  [self.testedApplication query];
  [self.testedApplication resolve];
  XCTAssertNotNil(self.testedApplication.fb_tree);
  XCTAssertNotNil(self.testedApplication.fb_accessibilityTree);
}

- (void)testDeactivateApplication
{
  [self.testedApplication query];
  [self.testedApplication resolve];
  NSError *error;
  XCTAssertTrue([self.testedApplication fb_deactivateWithDuration:1 error:&error]);
  XCTAssertNil(error);
  XCTAssertTrue(self.testedApplication.buttons[@"Show alert"].fb_isVisible);
}

- (void)testActiveApplication
{
  XCTAssertTrue([FBApplication fb_activeApplication].buttons[@"Show alert"].fb_isVisible);
  [self goToSpringBoard];
  XCTAssertTrue([FBApplication fb_activeApplication].icons[@"Safari"].fb_isVisible);
}

@end