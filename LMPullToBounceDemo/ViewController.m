//
//  ViewController.m
//  WKPullToBounce
//
//  Created by luck-mac on 15/8/18.
//  Copyright (c) 2015年 com.nju.luckymore. All rights reserved.
//

#import "ViewController.h"
#import "UIView+PullToBounce.h"
#import "SampleTableViewCell.h"
#import "LMPullToBounceWrapper.h"
#import "NSTimer+PullToBounce.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) LMPullToBounceWrapper *pushToBounceWrapper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mockHeader];
    self.view.backgroundColor = [UIColor colorWithRed:0.421593 green:0.657718 blue:0.972549 alpha:1];
    CGRect bodyViewFrame = CGRectMake(0, 20 + 44, self.view.frame.size.width, self.view.frame.size.height);
    UIView *bodyView = [[UIView alloc] initWithFrame:bodyViewFrame];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SampleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SampleTableViewCell class])];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bodyView];
    self.pushToBounceWrapper = [[LMPullToBounceWrapper alloc] initWithScrollView:tableView];
    [bodyView addSubview:self.pushToBounceWrapper];
    WS(weakSelf);
    [self.pushToBounceWrapper setDidPullTorefresh:^(){
        [NSTimer schedule:2.0 handler:^(CFRunLoopTimerRef timer) {
            [weakSelf.pushToBounceWrapper stopLoadingAnimation];
        }];
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)dealloc {
    NSLog(@"old one dealloc succeed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mockHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    header.backgroundColor = [UIColor colorWithRed:0.700062 green:0.817345 blue:0.972549 alpha:1];
    [self.view addSubview:header];
    
    UIView *headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 8)];
    headerLine.layer.cornerRadius = headerLine.height;
    headerLine.backgroundColor = [UIColor whiteColor];
    headerLine.center = CGPointMake(header.center.x, 20+44/2);
    [header addSubview:headerLine];
}

#pragma mark - UITableViewDatasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SampleTableViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"detail" sender:nil];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
