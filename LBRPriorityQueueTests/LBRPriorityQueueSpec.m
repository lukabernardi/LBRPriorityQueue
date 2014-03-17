//
//  LBRPriorityQueueSpec.m
//  LBRPriorityQueue
//
//  Created by Luca Bernardi on 06/03/14.
//  Copyright 2014 Luca Bernardi. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "LBRPriorityQueue.h"

SPEC_BEGIN(LBRPriorityQueueSpec)

describe(@"A priority queue", ^{
    
    context(@"When add an element", ^{
        __block LBRPriorityQueue *queue;
        __block id anObject;
        
        beforeEach(^{
            queue = [[LBRPriorityQueue alloc] init];
            anObject = [NSObject new];
            [queue push:anObject priority:0];
        });
        
        it(@"should be able to pop it", ^{
            id popObject = [queue pop];
            [[anObject should] equal:popObject];
        });
        
        it(@"should have count of 1", ^{
            [[@([queue count]) should] equal:@(1)];
        });
        
        it(@"should contains the pushed object", ^{
            [[@([queue containsObject:anObject]) should] beYes];
        });
        
        it(@"should be able to peek it without removing from the queue", ^{
            [[[queue peek] should] equal:anObject];
            [[@([queue count]) should] equal:@(1)];
        });
    });
    
    context(@"init as a min heap", ^{
        __block LBRPriorityQueue *queue;
        
        beforeEach(^{
            queue = [[LBRPriorityQueue alloc] initWithMinHeap];
        });
        
        context(@"When add elements with different priority", ^{
            
            it(@"should pop the element ordered by priority ", ^{
                NSObject *obj1 = [NSObject new];
                NSObject *obj2 = [NSObject new];
                NSObject *obj3 = [NSObject new];
                
                [queue push:obj1 priority:10];
                [queue push:obj2 priority:1];
                [queue push:obj3 priority:5];
                
                id popObject = nil;
                
                popObject = [queue pop];
                [[popObject should] equal:obj2];
            });
        });
    });
    
    context(@"init as a max heap", ^{
        __block LBRPriorityQueue *queue;
        
        beforeEach(^{
            queue = [[LBRPriorityQueue alloc] initWithMaxHeap];
        });
        
        context(@"When add elements with different priority", ^{
            
            it(@"should pop the element with the greates priority ", ^{
                NSObject *obj1 = [NSObject new];
                NSObject *obj2 = [NSObject new];
                NSObject *obj3 = [NSObject new];
                
                [queue push:obj1 priority:10];
                [queue push:obj2 priority:1];
                [queue push:obj3 priority:5];
                
                id popObject = nil;
                
                popObject = [queue pop];
                [[popObject should] equal:obj1];
            });
        });
    });
});

SPEC_END
