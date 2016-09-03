//
//  SpinnerLayer.h
//  LMPullToBounceDemo
//
//  Created by WangKun on 16/9/3.
//  Copyright © 2016年 com.nju.luckymore. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
typedef void (^AnimationCompletion)();
@interface SpinnerLayer :CAShapeLayer
- (void)animation;
- (void)stopAnimation;
- (instancetype)initWithSuperLayoutFrame:(CGRect)superLayerFrame
                                ballSize:(CGFloat)ballSize
                                   color:(UIColor *)color;
@end
