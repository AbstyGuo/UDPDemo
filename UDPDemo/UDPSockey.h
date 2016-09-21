//
//  UDPSockey.h
//  UDPDemo
//
//  Created by guoyf on 16/9/20.
//  Copyright © 2016年 guoyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface UDPSockey : NSObject<GCDAsyncUdpSocketDelegate>

@property(nonatomic,strong)GCDAsyncUdpSocket * ASocket;

@end
