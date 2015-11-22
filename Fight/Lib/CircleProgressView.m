//
//  CircleProgressView.m
//  Fight
//
//  Created by 锄禾日当午 on 15/11/20.
//  Copyright © 2015年 B&K. All rights reserved.
//
#define NUMBERLIMIT 10.0
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]   
#define RGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]      
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define CIRCLERADIUS 100.0f
#import "CircleProgressView.h"
#import "PulsingHaloLayer.h"

@interface CircleProgressView()
@property (nonatomic,strong)CAShapeLayer *topProgressLayer;
@property (nonatomic,assign)double initialTime;
@property (nonatomic,strong)UILabel *label;

@end
@implementation CircleProgressView
-(void)setStrokeEnd:(double)strokeEnd
{
    _strokeEnd = strokeEnd;
    // 给这个layer添加动画效果
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 1;
//    pathAnimation.fromValue = [NSNumber numberWithFloat:self.initialTime];
//    pathAnimation.toValue = [NSNumber numberWithFloat:self.strokeEnd];
//    [self.topProgressLayer addAnimation:pathAnimation forKey:nil];
    self.topProgressLayer.speed = 0.5;
    self.initialTime = self.strokeEnd;
    self.topProgressLayer.strokeEnd = strokeEnd;
    
}

-(void)setNumber:(NSInteger)number{
    PulsingHaloLayer *pulsingHaloLayer = [[PulsingHaloLayer alloc] initWithRepeatCount:2];
    pulsingHaloLayer.frame = CGRectMake(CIRCLERADIUS/2.0, CIRCLERADIUS/2.0, 0, 0);
//    [self.layer addSublayer:pulsingHaloLayer];
    [self.layer insertSublayer:pulsingHaloLayer below:self.label.layer];
    pulsingHaloLayer.haloLayerNumber = 1;
    pulsingHaloLayer.radius = CIRCLERADIUS*2;
    [pulsingHaloLayer setBackgroundColor:RandColor.CGColor];
    pulsingHaloLayer.animationDuration = 2.5;
    
    
        _number = number%10;
        self.label.text = [NSString stringWithFormat:@"%ld",(long)_number];
        self.strokeEnd = self.number/NUMBERLIMIT;
    if(number == 0){
        self.topProgressLayer.strokeColor = RandColor.CGColor;
    }
}

-(UILabel *)label{
    if(_label== nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont fontWithName:@"STHeitiK-Medium" size:25];
        label.font = [UIFont boldSystemFontOfSize:50];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setUp];
        self.strokeEnd = 0;
        self.initialTime = 0;
        self.number = 0;
        self.label.text = [NSString stringWithFormat:@"%ld",(long)self.number];
    }
    return self;
}


-(void)setUp{

    
    self.backgroundColor = [UIColor clearColor];
    //最底层
    CAShapeLayer *bottomLayer1 = [self getLayerInView:self];
    bottomLayer1.lineWidth     = 40.0f;
//    bottomLayer1.strokeColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.2f].CGColor;
    bottomLayer1.strokeColor  = [UIColor yellowColor].CGColor;
    //透明部分
    CAShapeLayer *bottomLayer2 = [self getLayerInView:self];
    bottomLayer2.strokeColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.6f].CGColor;
    //变化部分
    self.topProgressLayer = [self getLayerInView:self];
    self.topProgressLayer.strokeEnd = 0;
}




-(CAShapeLayer *)getLayerInView:(UIView *)showView
{
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CIRCLERADIUS, CIRCLERADIUS)
                                                        radius:CIRCLERADIUS
                                                    startAngle:0
                                                      endAngle:M_PI * 2
                                                     clockwise:YES];
    // 创建一个shapeLayer
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame         = showView.bounds;                // 与showView的frame一致
    layer.strokeColor   = [UIColor whiteColor].CGColor;   // 边缘线的颜色
    layer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer.lineCap       = kCALineCapRound;               // 边缘线的类型
    
    layer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
    layer.lineWidth     = 20.0f;                           // 线条宽度
    layer.strokeStart   = 0.0f;
    // 将layer添加进图层
    [showView.layer addSublayer:layer];
    return layer;
}

@end
