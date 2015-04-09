//
//  FibonacciSequenceTest.m
//  FibonacciSequence
//
//  Created by ducksan on 10/04/15.
//  Copyright (c) 2015 polyglot-fun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FibonacciSequence.h"

@interface FibonacciSequenceTest : XCTestCase

@end

@implementation FibonacciSequenceTest

- (void)testZeroToOne {
    FibonacciSequence *obj = [FibonacciSequence alloc];
    XCTAssertEqual(0, [obj calculate:0]);
    XCTAssertEqual(1, [obj calculate:1]);
}

- (void)testTwoToFour {
    FibonacciSequence *obj = [FibonacciSequence alloc];
    XCTAssertEqual(1, [obj calculate:2]);
    XCTAssertEqual(2, [obj calculate:3]);
    XCTAssertEqual(3, [obj calculate:4]);
}

- (void)testLarge {
    FibonacciSequence *obj = [FibonacciSequence alloc];
    XCTAssertEqual(5, [obj calculate:5]);
    XCTAssertEqual(144, [obj calculate:12]);
}

- (void)testNegativeOneToNegativeFour {
    FibonacciSequence *obj = [FibonacciSequence alloc];
    XCTAssertEqual(1, [obj calculate:-1]);
    XCTAssertEqual(-1, [obj calculate:-2]);
    XCTAssertEqual(2, [obj calculate:-3]);
    XCTAssertEqual(-3, [obj calculate:-4]);
}

@end
