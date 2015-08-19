//
//  WaveView.h
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import <UIKit/UIKit.h>

typedef void (^EndPullHandler)();
@interface WaveView : UIView
@property (nonatomic, strong) EndPullHandler didEndPull;
- (instancetype) initWithFrame:(CGRect)frame
                bounceDuration:(CFTimeInterval) duration
                         color:(UIColor *)color;
- (void)wave:(CGFloat)y;
- (void)didReleaseWithAmountX:(CGFloat)amountX amountY:(CGFloat)amountY;
@end
