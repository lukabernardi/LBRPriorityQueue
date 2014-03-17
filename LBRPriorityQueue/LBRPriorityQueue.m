//
//  LBRPriorityQueue.m
//  LBRPriorityQueue
//
//  Created by Luca Bernardi on 06/03/14.
//  Copyright (c) 2014 Luca Bernardi. All rights reserved.
//

#import "LBRPriorityQueue.h"

#pragma mark - TRSPriorityQueueNode

@interface TRSPriorityQueueNode : NSObject
@property (nonatomic, strong) id value;
@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, strong) NSComparator comparator;
@end

@implementation TRSPriorityQueueNode
@end


#pragma mark - LBRPriorityQueue


CFComparisonResult LBRPriorityQueueComparsionCallback (const void *ptr1, const void *ptr2, void *info);
void LBRPriorityQueueApplyCallBack (const void *val, void *context);

@interface LBRPriorityQueue ()
@property (nonatomic, copy) void(^enumerationBlock)(id object);
@property (nonatomic, copy) NSComparator comparator;
@end

@implementation LBRPriorityQueue {
    CFBinaryHeapRef _binaryHeap;
}

#pragma mark - Init & Dealloc

- (void)dealloc
{
    CFRelease(_binaryHeap);
}

- (instancetype)init
{
    return [self initWithMinHeap];
}

- (instancetype)initWithComparator:(NSComparator)comparator
{
    NSParameterAssert(comparator);
    
    if (self) {
        _comparator = comparator;
        
        CFBinaryHeapCallBacks callbacks = {
            .version         = 0,
            .retain          = kCFStringBinaryHeapCallBacks.retain,
            .release         = kCFStringBinaryHeapCallBacks.release,
            .copyDescription = kCFStringBinaryHeapCallBacks.copyDescription,
            .compare         = &LBRPriorityQueueComparsionCallback,
        };
        
        _binaryHeap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, NULL);
    }
    return self;
}

- (instancetype)initWithMinHeap
{
    NSComparator comparator = ^NSComparisonResult(TRSPriorityQueueNode *obj1, TRSPriorityQueueNode *obj2) {
        return [@(obj1.priority) compare:@(obj2.priority)];
    };
    return [self initWithComparator:comparator];
}

- (instancetype)initWithMaxHeap
{
    NSComparator comparator = ^NSComparisonResult(TRSPriorityQueueNode *obj1, TRSPriorityQueueNode *obj2) {
        return [@(obj2.priority) compare:@(obj1.priority)];
    };
    return [self initWithComparator:comparator];
}

#pragma mark - API

- (void)push:(id)anObject priority:(NSUInteger)priority
{
    TRSPriorityQueueNode *node = [TRSPriorityQueueNode new];
    node.value      = anObject;
    node.priority   = priority;
    node.comparator = self.comparator;
    
    NSAssert(_binaryHeap, nil);
    CFBinaryHeapAddValue(_binaryHeap, (void *)node);
}

- (id)pop
{
    id value = [self peek];
    CFBinaryHeapRemoveMinimumValue(_binaryHeap);
    return value;
}

- (id)peek
{
    TRSPriorityQueueNode *node = (TRSPriorityQueueNode *)CFBinaryHeapGetMinimum(_binaryHeap);
    if (node) {
        return node.value;
    }
    return nil;
}

- (NSInteger)count
{
    return (NSInteger)CFBinaryHeapGetCount(_binaryHeap);
}

- (BOOL)containsObject:(id)anObject
{
    __block BOOL contains = NO;
    [self enumerateObjectsUsingBlock:^(id obj) {
        if ([obj isEqual:anObject]) {
            contains = YES;
        }
    }];
    return contains;
}

- (void)enumerateObjectsUsingBlock:(void(^)(id obj))block
{
    CFBinaryHeapApplyFunction(_binaryHeap, &LBRPriorityQueueApplyCallBack, (void *)block);
}

@end

CFComparisonResult
LBRPriorityQueueComparsionCallback (
                                    const void *ptr1,
                                    const void *ptr2,
                                    void *info
                                   )
{
    TRSPriorityQueueNode *node1 = (__bridge TRSPriorityQueueNode *)ptr1;
    TRSPriorityQueueNode *node2 = (__bridge TRSPriorityQueueNode *)ptr2;
    NSCAssert(node1.comparator == node2.comparator, @"All the node should have the same comparator");
    NSCAssert(node1.comparator != nil, nil);
    
    NSComparator comparator = node1.comparator;
    return (CFComparisonResult)comparator(node1, node2);
}

void
LBRPriorityQueueApplyCallBack (
                                const void *val,
                                void *context
                              )
{
    void(^block)(id object) = (__bridge void (^)(__strong id))(context);
    if (block) {
        TRSPriorityQueueNode *node = (__bridge TRSPriorityQueueNode *)(val);
        block(node.value);
    }
}