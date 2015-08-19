//
//  NSTimer+PullToBounce.m
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import "NSTimer+PullToBounce.h"

@implementation NSTimer (PullToBounce)
+ (CFRunLoopTimerRef)schedule:(NSTimeInterval)delay handler:(void (^)(CFRunLoopTimerRef))handler {
    NSTimeInterval fireDate = CFAbsoluteTimeGetCurrent() + delay;
    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler);
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
    return timer;
}
@end
