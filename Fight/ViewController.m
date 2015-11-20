//
//  ViewController.m
//  Fight
//
//  Created by 锄禾日当午 on 15/11/20.
//  Copyright © 2015年 B&K. All rights reserved.
//
#define ATTACKLIMIT 10.0f
#define LIFELIMIT 100.0f

#import "ViewController.h"
#import "CircleProgressView.h"
#import "ZDProgressView.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <CoreGraphics/CoreGraphics.h>
#define SERVICE_TYPE @"etayu"


@interface ViewController ()<MCSessionDelegate,MCBrowserViewControllerDelegate>
@property (nonatomic, strong)CircleProgressView *circleProgressView;
@property (nonatomic,strong)ZDProgressView *progressView;
//生命栏
@property (nonatomic,strong)ZDProgressView *lifeProgressView;

//链接
@property(nonatomic,retain) MCPeerID *peelId;
@property (nonatomic,retain)MCPeerID *anotherPeelId;
@property(nonatomic,retain) MCSession *session;
@property(nonatomic,retain) MCAdvertiserAssistant *advertiserAssistant;
@property(nonatomic,retain) MCBrowserViewController *browser;


@end

@implementation ViewController
static NSInteger attackCount = 0;
static NSInteger life = 100;
static const int attackEnergy = 10;
static NSInteger defend = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化界面
    [self setUpView];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1/60.0f;
    
    //链接设置
    [self linkSetup];
    
}

-(void)linkSetup
{
    self.peelId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    NSLog(@"%@",self.peelId);
    self.session = [[MCSession alloc] initWithPeer:_peelId];
    _session.delegate = self;
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:_session] ;
    [_advertiserAssistant start];
}

//fight按钮
- (IBAction)fightClick:(id)sender {
    if (nil == _browser) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:_session] ;
        _browser.delegate = self;
    }
    [self presentViewController:_browser animated:YES completion:nil];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    static NSInteger shakeCount=0;
    static NSDate *shakeStart;
    
    NSDate *now=[[NSDate alloc] init];
    NSDate *checkDate=[[NSDate alloc] initWithTimeInterval:0.1f sinceDate:shakeStart];
    
    if ([now compare:checkDate]==NSOrderedDescending || shakeStart ==nil) {
        shakeStart=[[NSDate alloc] init];
        //增加点数
        if (fabs(acceleration.x)>2.0 || fabs(acceleration.y)>2.0 || fabs(acceleration.z)>2.0 ) {
            shakeCount++;
            self.circleProgressView.number = shakeCount;
            NSLog(@"%ld",(long)shakeCount);
            if(shakeCount == 10){
                attackCount++;
                shakeCount = 0;
            }
    
        }
        //发出招式
        if (fabs(acceleration.x)>5.0 || fabs(acceleration.y)>5.0 || fabs(acceleration.z)>5.0 ) {
            if(attackCount>0){
                attackCount--;
                if(self.browser!=nil){
                    NSLog(@"发送信息");
                    NSData *data = [NSData dataWithBytes: &attackEnergy length: sizeof(attackEnergy)];
                    [self.session sendData:data toPeers:@[self.anotherPeelId] withMode:MCSessionSendDataReliable error:nil];
                }
                
            }
        }
    }
    
    [self updateView];
}



-(void)setUpView
{
    self.view.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.4f];
    
    
    CircleProgressView *circleProgressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    circleProgressView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.view addSubview:circleProgressView];
    self.circleProgressView = circleProgressView;

    //增加攻击栏
    ZDProgressView *progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, 2*self.view.bounds.size.width/3, 40)];
    progressView.center = CGPointMake(self.view.bounds.size.width/2, 50);
    progressView.text = [NSString stringWithFormat:@"fight值:%d",attackCount];
    progressView.progress = attackCount/ATTACKLIMIT;
    progressView.prsColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    //添加生命栏
    ZDProgressView *lifeProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, 2*self.view.bounds.size.width/3, 40)];
    lifeProgressView.center = CGPointMake(self.view.bounds.size.width/2, 60+self.progressView.frame.size.height);
    lifeProgressView.text = [NSString stringWithFormat:@"生命值:%d",life];
    lifeProgressView.progress = life/LIFELIMIT;
    lifeProgressView.prsColor = [UIColor whiteColor];
    [self.view addSubview:lifeProgressView];
    self.lifeProgressView = lifeProgressView;
    
}

-(void)updateView{
    self.progressView.text = [NSString stringWithFormat:@"fight值:%d",attackCount];
    self.progressView.progress = attackCount/ATTACKLIMIT;
    self.lifeProgressView.text = [NSString stringWithFormat:@"生命值:%ld",(long)life];
    self.lifeProgressView.progress = life/LIFELIMIT;

}

//链接相关

#pragma mark- MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    //    NSLog(@"session:%@ peer:%@ didChangeState:%ld",session,peerID,(long)state);
    NSLog(@"lalalaaal%@",peerID);
    self.anotherPeelId = peerID;
    NSLog(@"环境改变");
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    //    NSLog(@"session:%@ didReceiveData:%@ fromPeer:%@",session,data,peerID);
    //    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //
    //    if([str isEqual:@"you win"]){
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"you win" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    //        [alert show];
    //        [self clearClick:nil];
    //    }
    NSLog(@"受到伤害");
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    int attack = [str intValue];
    NSLog(@"attack:%d",attack);
    //    life -= num;
    int destroy = attackEnergy-defend;
    
    NSLog(@"%d",defend);
    if(destroy>=0){
        life= life - destroy;
        [self updateView];
       
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if(life<=0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"you lose" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert show];
                [self clear];
                NSData *data =  [@"you win" dataUsingEncoding:NSUTF8StringEncoding];
                [self.session sendData:data toPeers:@[self.anotherPeelId] withMode:MCSessionSendDataReliable error:nil];
            }
            
        });
    }
}

-(void)clear{
    life =0;
    attackCount = 0;
    [self updateView];
    self.circleProgressView.number = 0;
    
}
// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    //    NSLog(@"session:%@ didReceiveStream:%@ fromPeer:%@",session,stream,peerID);
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    //    NSLog(@"session:%@ didStartReceivingResourceWithName:%@ fromPeer:%@ withProgress:%@",session,resourceName,peerID,progress);
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    //    NSLog(@"session:%@ didStartReceivingResourceWithName:%@ fromPeer:%@ atURL:%@ withError:%@",session,resourceName,peerID,localURL,error);
}

#pragma mark- MCBrowserViewControllerDelegate
// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    //    NSLog(@"browserViewControllerDidFinish:%@",browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    //    NSLog(@"browserViewControllerWasCancelled:%@",browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
