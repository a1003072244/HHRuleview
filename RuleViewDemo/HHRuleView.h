//
//  HHRuleView.h
//  RuleViewDemo
//
//  Created by ZHH on 16/11/10.
//  Copyright © 2016年 zhh. All rights reserved.
//  企鹅&微信 1003072244

#import <UIKit/UIKit.h>

@class HHRuleView;

@protocol HHRuleViewDelegate <NSObject>


@optional
- (void)ruleViewDidScroll:(HHRuleView *)ruleView pointValue:(CGFloat)value;

@end

@interface HHRuleView : UIView


@property (nonatomic, assign)BOOL isRound;//!< 是否最小偏移量为刻度尺的一小格

@property (nonatomic, assign)NSInteger defaultValue;//!< 默认值

@property (nonatomic, strong)UITextField *chooseValueTF;//!< 刻度尺的值
@property (nonatomic, strong)UILabel *incomeLabel;//!< 收益
@property (nonatomic, assign)CGFloat incomeRate;//!< 投入金额与收益金额的比例值

@property (nonatomic, weak)id<HHRuleViewDelegate> delegate;//!< 代理

+(HHRuleView *)ruleViewWithMaxValue:(NSInteger)maxValue minValue:(NSInteger)minValue scale:(NSInteger)scale frame:(CGRect)frame;


@end

