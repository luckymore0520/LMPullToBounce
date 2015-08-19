//
//  NSTimer+PullToBounce.h
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (PullToBounce)
+ (CFRunLoopTimerRef)schedule:(NSTimeInterval)delay handler:(void (^)(CFRunLoopTimerRef))handler;
@end
