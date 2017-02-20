//
//  RetainedViewController.m
//  WCRetainCycleCheckerDemo
//
//  Created by WangCe on 20/02/2017.
//  Copyright © 2017 WangCe. All rights reserved.
//

#import "RetainedViewController.h"

@interface RetainedViewController ()

@property (nonatomic, strong) void(^aBlock)();

@end

@implementation RetainedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.aBlock = ^{
        NSLog(@"Call %@ in block", self);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
