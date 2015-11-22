//
//  SetupViewController.m
//  Fight
//
//  Created by 锄禾日当午 on 15/11/22.
//  Copyright © 2015年 B&K. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createCloseButton];
}

- (void)createCloseButton
{
    CGFloat width = 50;
    CGFloat height = width;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    closeButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-10-height/2);
    
    [closeButton setBackgroundColor:[UIColor yellowColor]];
    [closeButton setTitle:@"back" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(didCloseButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    closeButton.layer.cornerRadius = 25;
    [self.view addSubview:closeButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didCloseButtonTouch{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
