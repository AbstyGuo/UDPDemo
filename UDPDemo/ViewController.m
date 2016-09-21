//
//  ViewController.m
//  UDPDemo
//
//  Created by guoyf on 16/9/20.
//  Copyright © 2016年 guoyf. All rights reserved.
//

#import "ViewController.h"
#import "UdpSocketController.h"
@interface ViewController ()<GCDAsyncUdpSocketDelegate>
{
    int x , y;
}
@property (weak, nonatomic) IBOutlet UITextField *hostField;

@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    x = 0;
    y = 0;
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    UdpSocketController * socket = [UdpSocketController shareInstance];
    __weak typeof(self) ws = self;
   
    NSMutableData * dataS = [[NSMutableData alloc] init];
    
    socket.receive = ^(NSData * data){
        dispatch_async(dispatch_get_main_queue(), ^{
            static NSString * slv;
            if (x == 0) {
                slv = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                x++;
                [dataS appendData:data];
                UIImage * image = [UIImage imageWithData:data];
                
                ws.imageView.image = image;
                
                NSString * text = [NSString stringWithFormat:@"%@,个数%d,大小%.0fKB",slv, x ,dataS.length/1024.0];
                ws.contentLabel.text = text;

            }else{
                x++;
                [dataS appendData:data];
                UIImage * image = [UIImage imageWithData:data];
                
                ws.imageView.image = image;
                
                NSString * text = [NSString stringWithFormat:@"%@,个数%d,大小%.0fKB",slv, x ,dataS.length/1024.0];
                ws.contentLabel.text = text;

            }
                   });
        
    };
        
    [socket startUdpServer];

}



- (IBAction)sendClick:(UIButton *)sender {
    UdpSocketController * socket = [UdpSocketController shareInstance];
    static NSData * data;
    if (!data) {
        data = [[NSMutableData alloc] init];
    }
//
    float num = 30.0;
    for (int i = 0; i < 1000; i++) {
        y++;
        data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_login@2x" ofType:@"jpg"]];
        
        if (i == 0) {
            NSString * string = [NSString stringWithFormat:@"每秒传输%.3f",data.length*num/1024/1024];
            [socket sendMessage:self data:[string dataUsingEncoding:NSUTF8StringEncoding]  toHost:self.hostField.text Port:60000 Tag:100];
        }else{
            [socket sendMessage:self data:data  toHost:self.hostField.text Port:60000 Tag:100];
        }
        
        [NSThread sleepForTimeInterval:1.0f/num];
    }
    
//    if (sender.tag == 100) {
//       
//        
//        data = UIImagePNGRepresentation([UIImage imageNamed:@"default_message.png"]);
//        sender.tag = 101;
//    }else if (sender.tag == 101){
//        data = UIImagePNGRepresentation([UIImage imageNamed:@"ffb@2x.png"]);
//        sender.tag = 102;
//    }else{
//        
//         data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_login@2x" ofType:@"jpg"]];
//        
//        sender.tag = 100;
//    }
//    [socket sendMessage:self data:data  toHost:self.hostField.text Port:[self.portField.text intValue] Tag:100];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"发送成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"发送失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error{
    NSLog(@"%@",error);
}

/*
 - (IBAction)startServer:(id)sender {
 
 int port = 3339;
 
 NSError *error = nil;
 
 if (![udpServer bindToPort:port error:&error]) {
 
 NSLog(@"Error starting server (bind): %@", error);
 
 return;
 
 }
 
 if (![udpServer enableBroadcast:YES error:&error]) {
 
 NSLog(@"Error enableBroadcast (bind): %@", error);
 
 return;
 
 }
 
 if (![udpServer joinMulticastGroup:@"224.0.0.1"  error:&error]) {
 
 NSLog(@"Error joinMulticastGroup (bind): %@", error);
 
 return;
 
 }
 
 if (![udpServer beginReceiving:&error]) {
 
 [udpServer close];
 
 NSLog(@"Error starting server (recv): %@", error);
 
 return;
 
 }
 
 NSLog(@"udp servers success starting %hd", [udpServer localPort]);
 
 isRunning =true;
 
 }
 */

@end
