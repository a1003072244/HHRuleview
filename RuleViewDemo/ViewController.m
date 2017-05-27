//
//  ViewController.m
//  RuleViewDemo
//
//  Created by ZHH on 16/11/10.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "ViewController.h"
#import "HHRuleView.h"

@interface ViewController ()<HHRuleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HHRuleView *ruleView = [HHRuleView ruleViewWithMaxValue:50000 minValue:0 scale:1000 frame:CGRectMake(0, 200, 320, 200)];
    ruleView.center = self.view.center;
    ruleView.delegate = self;
    ruleView.incomeRate = 0.0013;
//    ruleView.isRound = NO; //四舍五入开关
    [self.view addSubview:ruleView];
    
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)ruleViewDidScroll:(HHRuleView *)ruleView pointValue:(CGFloat)value {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
