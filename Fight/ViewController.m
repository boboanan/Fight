//
//  ViewController.m
//  Fight
//
//  Created by 锄禾日当午 on 15/11/20.
//  Copyright © 2015年 B&K. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"


@interface ViewController ()
@property (nonatomic, strong)CircleProgressView *circleProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化界面
    [self setUpView];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1/60.0f;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    static NSInteger shakeCount=0;
    static NSDate *shakeStart;
    
    NSDate *now=[[NSDate alloc] init];
    NSDate *checkDate=[[NSDate alloc] initWithTimeInterval:0.1f sinceDate:shakeStart];
    
    if ([now compare:checkDate]==NSOrderedDescending || shakeStart ==nil) {
        shakeStart=[[NSDate alloc] init];
        if (fabs(acceleration.x)>2.0 || fabs(acceleration.y)>2.0 || fabs(acceleration.z)>2.0 ) {
            shakeCount++;
            self.circleProgressView.number = shakeCount;
            NSLog(@"%ld",(long)shakeCount);
        }
    }
}

-(void)setUpView
{
    self.view.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.4f];
    
    
    CircleProgressView *circleProgressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    circleProgressView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.view addSubview:circleProgressView];
    self.circleProgressView = circleProgressView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
