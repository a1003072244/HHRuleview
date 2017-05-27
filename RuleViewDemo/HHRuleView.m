//
//  HHRuleView.m
//  RuleViewDemo
//
//  Created by ZHH on 16/11/10.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HHRuleView.h"
#import "UIColor+HexString.h"

#define HBackGroundColor [UIColor whiteColor]
#define HHeight [UIScreen mainScreen].bounds.size.height
#define HWidth self.frame.size.width
#define Hone [UIScreen mainScreen].bounds.size.width / 320.0

#define kFontOfSize(font) ([UIScreen mainScreen].bounds.size.width < 375 ? 0.8 : 1.0)*font
#define kFontSize(font) [UIFont systemFontOfSize:kFontOfSize(font)]
#define KHexColor(color) [UIColor colorWithHexString:color]


@interface HHRuleView()<UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;//!< 刻度尺

@property (nonatomic, assign)NSInteger maxValue;//!< 最大值
@property (nonatomic, assign)NSInteger minValue;//!< 最小值
@property (nonatomic, assign)NSInteger scale;//!< 刻度比例 一大格十小格的
@property (nonatomic, assign)NSInteger pointValue;//!< 指针指向的值
@property (nonatomic, strong)UIView *pointView;//!< 指针

@end

NSInteger ruleImageViewHeight = 18;//刻度尺图片高度
CGFloat scrollViewScaleForRuleView = 4.0; // 整个刻度尺高度占整个控件的比例
CGFloat ruleLineHeight = 1.4                                                                                                    ; //刻度尺两边线条的宽度
CGFloat topDistance = 12.0; //控件之间 垂直距离

@implementation HHRuleView

+(HHRuleView *)ruleViewWithMaxValue:(NSInteger)maxValue minValue:(NSInteger)minValue scale:(NSInteger)scale frame:(CGRect)frame{
    HHRuleView *ruleView = [HHRuleView new];
    ruleView.backgroundColor = HBackGroundColor;
    ruleView.maxValue = maxValue;
    ruleView.minValue = minValue;
    ruleView.scale = scale;
    ruleView.isRound = YES;
    ruleView.frame = frame;
    
    
    [ruleView setScrollView];
    [ruleView setPointView];
    [ruleView setChooseValueTF];
    [ruleView setIncomeLabel];
    
    return ruleView;
}

-(void)setScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    //刻度尺的位置
    self.scrollView.frame = CGRectMake(0, self.frame.size.height/2-self.frame.size.height/scrollViewScaleForRuleView/2-10, self.frame.size.width, self.frame.size.height/scrollViewScaleForRuleView);
    UIImage *ruleImage =[UIImage imageNamed:@"rule"];
    //放几张刻度尺图
    NSInteger multiple = (self.maxValue-self.minValue)%self.scale == 0 ? (self.maxValue-self.minValue)/self.scale : (self.maxValue-self.minValue)/self.scale + 1;
    CGFloat contSizeWith = ruleImage.size.width*multiple+HWidth;
    self.scrollView.contentSize=CGSizeMake(contSizeWith, self.frame.size.height/scrollViewScaleForRuleView);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.decelerationRate = 0;
    self.scrollView.bounces = NO;
    
    [self addSubview:self.scrollView];
    [self setImages];

}
-(void)setImages {
    NSInteger multiple = (self.maxValue-self.minValue)%self.scale == 0 ? (self.maxValue-self.minValue)/self.scale : (self.maxValue-self.minValue)/self.scale + 1;
    UIImage *ruleImage = [UIImage imageNamed:@"rule"];
    for (int a = 0; a < multiple; a++) {
        UIImageView *rule = [[UIImageView alloc] initWithImage:ruleImage];
        rule.frame = CGRectMake(HWidth/2+a*ruleImage.size.width, CGRectGetMaxY(self.scrollView.bounds)-ruleImageViewHeight, ruleImage.size.width, ruleImageViewHeight);
        rule.tag = 100+a;
        if (a == multiple-1) {
            [rule setImage:[UIImage imageNamed:@"ruleEnd"]];
        }
        [self.scrollView addSubview:rule];
        
        //放刻度尺标度
        [self setRuleImageValueWithIdx:a];
        
    }
    [self setRuleImageValueWithIdx:multiple];
    
    //刻度尺两边的线条
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height-ruleLineHeight, HWidth/2, ruleLineHeight)];
    lineImage.backgroundColor = KHexColor(@"cccccc");
    [self.scrollView addSubview:lineImage];
    UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.contentSize.width-HWidth/2, self.scrollView.frame.size.height-ruleLineHeight, HWidth/2, ruleLineHeight)];
    lineImage2.backgroundColor = lineImage.backgroundColor;
    [self.scrollView addSubview:lineImage2];
}
- (void)setRuleImageValueWithIdx:(NSInteger)idx {
    UIImage *image = [UIImage imageNamed:@"rule"];
    UILabel *label = [UILabel new];
    int labelX = HWidth/2 + image.size.width * idx - image.size.width/2;
    label.frame = CGRectMake(labelX, CGRectGetMaxY(self.scrollView.bounds)-ruleImageViewHeight-13, image.size.width, 10);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = [NSString stringWithFormat:@"%ld",  self.minValue + idx*self.scale];
    [self.scrollView addSubview:label];
}

- (void)setPointView {
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(HWidth/2.0-0.5, self.scrollView.frame.origin.y, 1, self.scrollView.frame.size.height)];
    pointView.backgroundColor = [UIColor redColor];
    [self addSubview:pointView];
}

- (void)setDefaultValue:(NSInteger)defaultValue {
    if (defaultValue > _maxValue) {
        _defaultValue = _maxValue;
    } else if (defaultValue < _minValue) {
        _defaultValue = _minValue;
    } else {
        _defaultValue = defaultValue;
    }
    self.chooseValueTF.text = [@(_defaultValue) stringValue];
    UIImage *ruleImage = [UIImage imageNamed:@"rule"];
    //刻度尺比例实际值
    CGFloat ruleLength = (CGFloat)self.scale/ruleImage.size.width;
    CGFloat transformX = (CGFloat)(_defaultValue-_minValue)/ruleLength;
    self.scrollView.contentOffset = CGPointMake(transformX, 0);
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f", [self.chooseValueTF.text integerValue]*self.incomeRate];
    [self scrollViewDidEndDecelerating:_scrollView];
    
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(ruleViewDidScroll:pointValue:)]) {
        UIImage *ruleImage = [UIImage imageNamed:@"rule"];
        //刻度尺比例实际值
        CGFloat ruleLength = (CGFloat)self.scale/ruleImage.size.width;
        //指针指向的刻度
        CGFloat value=0;
        //滑动的刻度值
        CGFloat scrollValue=0;

        CGFloat contentOffSetX =0;
        contentOffSetX  = scrollView.contentOffset.x;
        
        scrollValue= ruleLength*contentOffSetX;
        if (self.isRound) {
            value=[self changeHundredValueWithValue:scrollValue];
        }else{
            value=self.minValue+scrollValue;
        }
        value = value < self.minValue ? self.minValue : value;
        value = value > self.maxValue ? self.maxValue : value;
        self.pointValue = value;
        self.chooseValueTF.text = [NSString stringWithFormat:@"%d", (int)self.pointValue];
        self.incomeLabel.text = [NSString stringWithFormat:@"%.2f", [self.chooseValueTF.text integerValue]*self.incomeRate];
        [self.delegate ruleViewDidScroll:self pointValue:self.pointValue];
    }
    
}



//调控偏移的距离
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self controlScrollViewContentOffSet:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self controlScrollViewContentOffSet:scrollView];
}
- (void)controlScrollViewContentOffSet:(UIScrollView *)scrollView {
    if (self.isRound) {
        UIImage *ruleImage = [UIImage imageNamed:@"rule"];
        //刻度尺比例实际值
        CGFloat ruleLength = self.scale/ruleImage.size.width;
        CGFloat resultContentX = (self.pointValue-self.minValue)/ruleLength;
        scrollView.contentOffset = CGPointMake(resultContentX, 0);
    }
}




- (NSInteger)changeHundredValueWithValue:(CGFloat)value {
    NSInteger result = 0;
    NSInteger oneTenth = self.scale/10;

    
    
    if ((int)value % oneTenth > oneTenth/2) {
        result = ((int)value/oneTenth+1)*oneTenth;
    } else {
        result = ((int)value/oneTenth)*oneTenth;
    }
    
    if (result > self.maxValue) {
        return self.maxValue;
    }
    
    return result + self.minValue;
}


#pragma mark - TF&Label&Image 控件排放
- (void)setChooseValueTF {
    self.chooseValueTF = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, self.scrollView.frame.origin.y-self.scrollView.bounds.size.height/5*3, 100, self.scrollView.bounds.size.height/5*3)];
    self.chooseValueTF.text = [@(self.minValue) stringValue];
    self.chooseValueTF.textAlignment = NSTextAlignmentCenter;
    self.chooseValueTF.font = kFontSize(30);
    self.chooseValueTF.adjustsFontSizeToFitWidth = YES;
    self.chooseValueTF.keyboardType = UIKeyboardTypeNumberPad;
    self.chooseValueTF.textColor = KHexColor(@"f44141");
    self.chooseValueTF.delegate = self;
    [self addSubview:self.chooseValueTF];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.scrollView.frame.origin.y, 80, 1)];
    lineView.backgroundColor = KHexColor(@"e5e5e5");
    [self addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, self.chooseValueTF.frame.origin.y-10-topDistance, 100, 25)];
    titleLabel.textColor = KHexColor(@"999999");
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"投资金额(元)";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}


- (void)setIncomeLabel {

    
    self.incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.scrollView.frame)+topDistance*2, HWidth-80, 20)];
    self.incomeLabel.font = kFontSize(24);
    self.incomeLabel.textAlignment = NSTextAlignmentCenter;
    self.incomeLabel.textColor = KHexColor(@"ff9751");
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f", [self.chooseValueTF.text integerValue]*self.incomeRate];
    [self addSubview:self.incomeLabel];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(HWidth/2-70, CGRectGetMaxY(self.incomeLabel.frame)+topDistance-2, 140, 13)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = kFontSize(12);
    messageLabel.text = @"预期收益(元)";
    messageLabel.textColor = KHexColor(@"999999");
    [self addSubview:messageLabel];
    
    
}



#pragma mark - UITextFieldDelegate 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger value = [textField.text integerValue];
    NSString *message;
    if (value > self.maxValue) {
        message = [NSString stringWithFormat:@"您输入的值已超过最大值%ld", self.maxValue];
        self.defaultValue = self.maxValue;
    } else if (value < self.minValue){
        message = [NSString stringWithFormat:@"您输入的值低于最小值%ld", self.minValue];
        self.defaultValue = self.minValue;
    } else {
        self.defaultValue = value;
    }
    if (message.length > 0) {
        textField.text = [@(self.pointValue) stringValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [textField resignFirstResponder];
        [alert show];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}



@end
