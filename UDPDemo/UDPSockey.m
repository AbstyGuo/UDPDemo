//
////
////  UDPSockey.m
////  UDPDemo
////
////  Created by guoyf on 16/9/20.
////  Copyright © 2016年 guoyf. All rights reserved.
////
//
//#import "UDPSockey.h"
//
//@implementation UDPSockey
//{
//    NSMutableData * _readData;
//}
//+(UDPSockey *)sharedInstance
//{
//    static UDPSockey *sharedInstace =nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstace = [[self alloc]init];
//    });
//    return sharedInstace;
//}
////这里实例内存是因为请求的数据如果过大，socket需要分多次发送，避免多次被实例而丢失数据
//-(void)ShiLiBianLiang
//{
//    _readData = [[NSMutableData alloc]init];
//}
//
////发送数据处理
////typedata  -- 标记传输的数据是哪个功能模块的数据
////flag      -- 标记发送数据的类型   比如数据是对象？ 结构体？ int？
////  发送的contentData带\n服务器处理去掉\n
//-(void)socketSend:(NSData *)contentData :(Byte)Type :(Byte)flag11
//{
//    if (Type !='*' && flag11 !='W')
//    {
//        [self ShiLiBianLiang];
//    }
//    
//    const int DefaultSize =1024;//接收数据缓冲区大小
//    int sendCount =0;//已经发送的字节数
//    int len =0;//剩余发送的字节数
//    BOOL Flag =YES;//发送是否完成标记 是否需要继续循环
//    NSData *SendData;
//    NSData * TypeData = [[NSData alloc] initWithBytes:&Type length:sizeof(Type)];
//    NSData *flag = [[NSData alloc]initWithBytes:&flag11 length:sizeof(flag11)];
//    
//    //保证数据分开发送
//    do {
//        NSMutableData *SendDataAll= [NSMutableData dataWithData:TypeData];
//        if (contentData.length - sendCount >0 && sendCount > DefaultSize - 6)//大于缓冲区
//        {
//            SendData = [[NSData alloc]init];
//            SendData = [contentData subdataWithRange:NSMakeRange(sendCount, sendCount + DefaultSize -6)];//截取data发送
//            sendCount += DefaultSize -6;
//            len = contentData.length - sendCount;
//            //发送数据： typeData＋ flag＋大小 + 内容
//            int size = DefaultSize -6;
//            NSData *sizeData = [NSData dataWithBytes:&size length:sizeof(size)];
//            [SendDataAll appendData:flag];
//            [SendDataAll appendData:sizeData];
//            [SendDataAll appendData:SendData];
//            [_ASocket writeData:SendDataAll withTimeout:-1 tag:0];
//            NSLog(@"发送没有结束，此次发送大小:%lu",(unsigned long)SendDataAll.length);
//        }else//小于缓存区
//        {
//            //发送的数据格式: typeData＋ flag＋大小 +内容
//            SendData = [[NSData alloc]init];
//            SendData = [contentData subdataWithRange:NSMakeRange(sendCount, contentData.length)];
//            //发送数据 :typeData＋ flag＋大小 + 内容
//            int size = contentData.length - sendCount;
//            NSData *sizeData = [NSDatadataWithBytes:&sizelength:sizeof(size)];
//            NSLog(@"typeSize :%d,\n flagSize :%d,\n sizeDataSize :%d,\n contentSize :%d,",TypeData.length,flag.length,sizeData.length,contentData.length);
//            [SendDataAll appendData:flag];
//            [SendDataAll appendData:sizeData];
//            [SendDataAll appendData:SendData];
//            [_ASocket writeData:SendDataAll withTimeout:-1 tag:0];
//            NSLog(@"发送已经结束，最后发送大小:%lu",(unsigned long)SendDataAll.length);
//            Flag = NO;
//        }
//    }while (Flag);
//    
//    //当数据发送完成的时候，再次发送END通知socket数据发送完毕。
//    NSMutableData *EndSendData= [NSMutableData dataWithData:TypeData];
//    NSData *ENDData = [@"END" dataUsingEncoding:NSUTF8StringEncoding];
//    int size1 = ENDData.length;
//    NSData *sizeData = [NSData dataWithBytes:&size1 length:sizeof(size1)];
//    
//    NSLog(@"%hhu-%@-%@",flag11,[[NSString alloc]initWithData:sizeData encoding:NSASCIIStringEncoding],[[NSString alloc]initWithData:ENDData encoding:NSASCIIStringEncoding]);
//    
//    [EndSendData appendData:flag];
//    [EndSendData appendData:sizeData];
//    [EndSendData appendData:ENDData];
//    [_ASocket writeData:EndSendData withTimeout:-1 tag:0];
//}
//
////接收到数据，数据进行处理   ********  数据大的时候接收不到END结束标识  ********
//-(void)socketReceive :(NSData *)data
//{
//    NSError *error;
//    NSData *typedata = [data subdataWithRange:NSMakeRange(0,1)];
//    NSData *flagdata = [data subdataWithRange:NSMakeRange(1,1)];
//    NSData *contentdata = [data subdataWithRange:NSMakeRange(6, data.length-6)];
//    NSString *typeStr  = [[NSString alloc] initWithData:typedata encoding:NSUTF8StringEncoding];
//    NSString *flagStr  = [[NSString alloc]initWithData:flagdata encoding:NSUTF8StringEncoding];
//    NSString *contentStr = [[NSString alloc]initWithData:contentdata encoding:NSUTF8StringEncoding];
//    /**
//     *  ‘T’为json数据
//     */
//    if ([flagStr isEqualToString:@"T"] )
//    {
//        /**
//         *  *********  用户数据  *********
//         */
//        if ([typeStr isEqualToString:@"A"])
//        {
//            /**
//             *  数据全部接收完后返回dictionary，否则继续接收；
//             */
//            if ([contentStr isEqualToString:@"END"])
//            {
//                //接受完成，解析数据
//            }else
//            {
//                [_readData appendData:contentdata];
//                [self socketSend:[@"C" dataUsingEncoding:NSUTF8StringEncoding] :'*' :'W'];
//            }
//        }
//    }
//}
//
//// socket连接
//-(void)socketConnectHost{
//    self.ASocket    = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//    NSError *error =nil;
//    [self.ASocket connectToHost:self.socket HostonPort:self.socketPort withTimeout:10 error:&error];
//}
//
//// 心跳连接
//-(void)longConnectToSocket{
//    //根据服务器要求发送固定格式的数据，假设为指令一个字节"1"，但是一般不会是这么简单的指令
//    Byte bytee ='1';
//    NSData *longConnect = [[NSDataalloc]initWithBytes:&byteelength:sizeof(bytee)];
//    [self.ASocketwriteData:longConnectwithTimeout:1tag:1];
//}
//// 切断socket
//-(void)cutOffSocket{
//    self.ASocket.userData =SocketOfflineByUser;
//    [self.connectTimerinvalidate];
//    [self.ASocketdisconnect];
//}
//
//#pragma mark  -
////当socket连接并准备读和写
//-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
//{
//    self.connectTimer = [NSTimerscheduledTimerWithTimeInterval:30target:selfselector:@selector(longConnectToSocket)userInfo:nilrepeats:YES];
//    [self.connectTimerfire];
//    [self.ASocketreadDataWithTimeout:-1tag:0];
//}
////当socket已经完成到读取内存中的数据请求
//-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//{
//    //对得到的data值进行解析与转换即可
//    [selfsocketReceive:data];
//    [self.ASocketreadDataWithTimeout:-1tag:0];
//}
////socket发生错误的时候
//-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//}
//
////当socket完成写入的时候调用
//-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
//{
//}
////当这个socket是连接的时候，这个方法将会返回一个yes继续或者no停止
//-(BOOL)onSocketWillConnect:(AsyncSocket *)sock
//{
//    return YES;
//}
//
//-(void)onSocketDidDisconnect:(AsyncSocket *)sock
//{
//    NSLog(@"sorry连接失败， %ld",sock.userData);
//    if (sock.userData ==SocketOfflineByServer) {
//        // 服务器掉线，重连
//        [selfsocketConnectHost];
//    }
//    elseif (sock.userData ==SocketOfflineByUser) {
//        //如果由用户断开，不进行重连
//        return;
//    }
//}
//
//
//@end
