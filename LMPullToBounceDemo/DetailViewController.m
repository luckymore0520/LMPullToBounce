//
//  DetailViewController.m
//  LMPullToBounceDemo
//
//  Created by Kun Wang on 15/9/15.
//  Copyright (c) 2015年 com.nju.luckymore. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Detail"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)onDeallocButtonClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    [[UIApplication sharedApplication].delegate window].rootViewController = navigationController;
}
@end
