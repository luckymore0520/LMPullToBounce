//
//  CircleLayer.h
//  LMPullToBounceDemo
//
//  Created by WangKun on 16/9/3.
//  Copyright © 2016年 com.nju.luckymore. All rights reserved.
//

#import "SpinnerLayer.h"

@interface CircleLayer :CAShapeLayer
@property (nonatomic, assign) CGFloat moveUpDist;
@property (nonatomic, strong) SpinnerLayer *spiner;
@property (nonatomic, strong) AnimationCompletion didEndAnimation;
- (instancetype)initWithSize:(CGFloat)size
                  moveUpDist:(CGFloat)moveUpDist
              superViewFrame:(CGRect)superViewFrame
                       color:(UIColor *)color
                    timeFunc:(CAMediaTimingFunction *)timeFunc
                  upDuration:(CGFloat)upDuration;
- (void)startAnimation;
- (void)endAnimation:(AnimationCompletion)completion;
@end