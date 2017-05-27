# HHRuleview
P2P 理财投入收益计算刻度尺


滑动刻度尺，可设置最小滑动刻度数值，并支持是否以此最小刻度为移动单位。 也可以手动输入数值，刻度尺自动滑动。
下方会有一定的比例计算。触摸白色区域，回收键盘
应用场景：p2p app内理财投资收入预览。

使用实例：
```Objective-C
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
  //滑动刻度尺触发
}
```

效果图：<br>
![](https://github.com/a1003072244/HHRuleview/blob/master/Untitled.gif)
