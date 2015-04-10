//
//  FibonacciSequence.m
//  FibonacciSequence
//
//  Created by ducksan on 10/04/15.
//  Copyright (c) 2015 polyglot-fun. All rights reserved.
//

#import "FibonacciSequence.h"

@implementation FibonacciSequence
- (int)calculate:(int)index {
    if (index == 0 || index == 1) {
        return index;
    }
    if (index < 0) {
        return [self calculate:(index+2)] - [self calculate:(index+1)];
    } else {
        return [self calculate:(index-2)] + [self calculate:(index-1)];
    }
}
@end
