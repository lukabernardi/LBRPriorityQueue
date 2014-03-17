//
//  LBRPriorityQueue.h
//  LBRPriorityQueue
//
//  Created by Luca Bernardi on 06/03/14.
//  Copyright (c) 2014 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBRPriorityQueue : NSObject

- (instancetype)initWithComparator:(NSComparator)comparator;
- (instancetype)initWithMinHeap;
- (instancetype)initWithMaxHeap;

- (void)push:(id)anObject priority:(NSUInteger)priority;
- (id)pop;
- (id)peek;

- (NSInteger)count;
- (BOOL)containsObject:(id)anObject;

@end