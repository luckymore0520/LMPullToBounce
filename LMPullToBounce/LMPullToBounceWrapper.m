//
//  WKPullToBounceWrapper.m
//  
//
//  Created by luck-mac on 15/8/19.
//
//

#import "LMPullToBounceWrapper.h"
#import "BounceView.h"
#import "UIView+PullToBounce.h"

#define CONTENTOFFSET_KEYPATH @"contentOffset"

@interface LMPullToBounceWrapper()
@property (nonatomic, assign)CGFloat pullDist;
@property (nonatomic, assign)CGFloat bendDist;
@property (nonatomic, readonly) CGFloat stopPos;
@property (nonatomic, strong) BounceView *bounceView;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation LMPullToBounceWrapper
- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    return [self initWithScrollView:scrollView
                     bounceDuration:0.8
                           ballSize:36
                   ballMoveTimeFunc:[CAMediaTimingFunction functionWithControlPoints:0.49 :0.13 :0.29 :1.61]
                     moveUpDuration:0.25
                       pullDistance:96
                       bendDistance:40
                   didPullToRefresh:nil];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                     bounceDuration:(CFTimeInterval)bounceDuration
                           ballSize:(CGFloat)ballSize
                   ballMoveTimeFunc:(CAMediaTimingFunction *)ballMoveTimeFunc
                     moveUpDuration:(CFTimeInterval)moveUpDuration
                       pullDistance:(CGFloat)pullDistance
                       bendDistance:(CGFloat)bendDistance
                   didPullToRefresh:(DidPullToRefresh)didPullToRefresh {
    self = [self initWithFrame:scrollView.frame];
    if (self) {
        self.pullDist = pullDistance;
        self.bendDist = bendDistance;
        self.didPullTorefresh = didPullToRefresh;
        
        CGFloat moveUpDist = pullDistance / 2 + ballSize / 2;
        
        self.bounceView = [[BounceView alloc] initWithFrame:self.frame
                                             bounceDuration:bounceDuration
                                                   ballSize:ballSize
                                       ballMovingTimingFunc:ballMoveTimeFunc
                                             moveUpDuration:moveUpDuration
                                                 moveUpDist:moveUpDist
                                                      color:self.scrollView.backgroundColor];
        [self addSubview:self.bounceView];
        self.scrollView = scrollView;
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        [scrollView addObserver:self forKeyPath:CONTENTOFFSET_KEYPATH options:NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:CONTENTOFFSET_KEYPATH];
}

#pragma mark - Public
- (void)stopLoadingAnimation {
    WS(weakSelf);
    [self.bounceView endingAnimation:^{
        [weakSelf.scrollView setContentOffset:CGPointZero animated:YES];
        weakSelf.scrollView.scrollEnabled = YES;
    }];
}

#pragma mark - Getter
- (CGFloat)stopPos {
    return self.pullDist + self.bendDist;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:CONTENTOFFSET_KEYPATH]) {
        if ([object isKindOfClass:[UIScrollView class]]) {
            [self scrollViewDidScroll];
        }
    }
}

- (void)scrollViewDidScroll {
    UIScrollView *scrollView = self.scrollView;
    if (scrollView.contentOffset.y < 0) {
        CGFloat y = - scrollView.contentOffset.y;
        if (y < self.pullDist) {
            self.bounceView.top = y;
            [self.bounceView wave:0];
            self.scrollView.alpha = (self.pullDist - y)/self.pullDist;
        } else if ( y < self.stopPos) {
            [self.bounceView wave: y-self.pullDist];
            self.scrollView.alpha = 0;
        } else if (y > self.stopPos) {
            self.scrollView.scrollEnabled = NO;
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -[self stopPos]) animated:NO];
            self.bounceView.top = self.pullDist;
            [self.bounceView wave:(self.stopPos - self.pullDist)];
            [self.bounceView didRelease:(self.stopPos - self.pullDist)];
            if (self.didPullTorefresh) {
                self.didPullTorefresh();
            }
            self.scrollView.alpha = 0;
        }
    } else {
        CGRect frame = self.bounceView.frame;
        frame.origin.y = 0;
        self.bounceView.frame = frame;
        self.scrollView.alpha = 1;
    }
}



@end
