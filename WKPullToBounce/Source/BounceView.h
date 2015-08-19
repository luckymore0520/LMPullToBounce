//
//  BounceView.h
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import <UIKit/UIKit.h>
#import "BallView.h"
#import "WaveView.h"

@interface BounceView : UIView
- (instancetype)initWithFrame:(CGRect)frame
               bounceDuration:(CFTimeInterval)duration
                     ballSize:(CGFloat)ballSize
         ballMovingTimingFunc:(CAMediaTimingFunction *)ballMovingTimingFunc         moveUpDuration:(CFTimeInterval)moveUpDuration
                   moveUpDist:(CGFloat)moveUpDist
                        color:(UIColor *)color;

- (void)wave:(CGFloat)y;
- (void)didRelease:(CGFloat)y;
- (void)endingAnimation:(AnimationCompletion)completion;
@end
