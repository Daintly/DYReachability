//
//  DYNetNofication.m
//  DYReachability
//
//  Created by Dainty on 2018/9/1.
//  Copyright © 2018年 Dainty. All rights reserved.
//

#import "DYNetNofication.h"
#import "Reachability.h"
#import <arpa/inet.h>
#include <netdb.h>
@interface DYNetNofication ()
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) NSDictionary *networkDict ;
@end
@implementation DYNetNofication

static NSString *const hoststring = @"www.baidu.com";
+ (instancetype)defultNotification{
    
    static DYNetNofication *fication = nil;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!fication) {
            fication = [DYNetNofication new];
          
        }
    });
    return fication;
}


- (void)reachabilityChanged:(NSNotification*)notifi{
    BOOL reachStatus = [self.hostReachability currentReachabilityStatus];
    BOOL pingStatus  = pingtest();
    if (reachStatus&&pingStatus){
        self.networkStatus = self.netWorkDetailStatus;
    }else{
        self.networkStatus = DYNetworkStatusNone;
    }
    
}

- (void)dealloc{
    [self.hostReachability stopNotifier];
  
}
#pragma mark - function

- (void)startNotification{
    [self.hostReachability startNotifier];
  
}

- (void)stopNotification{
    [self.hostReachability stopNotifier];
  
}


- (void)setNetworkStatus:(DYNetworkStatus)networkStatus{
    if (_networkStatus != networkStatus) {
        _networkStatus = networkStatus;

    }
    NSLog(@"-----%@-----",[self.networkDict objectForKey:@(networkStatus)]);
    
    if ([self.delegate respondsToSelector:@selector(host:networkStatusDidChanged:)]) {
        [self.delegate host:hoststring networkStatusDidChanged:_networkStatus];
    }
}

- (Reachability *)hostReachability{
    if (!_hostReachability) {
        _hostReachability = [Reachability reachabilityWithHostName:hoststring];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
    }return _hostReachability;
}


/** 根据状态栏获取详细的网络状态*/
- (DYNetworkStatus)netWorkDetailStatus{
    UIApplication *app = [UIApplication sharedApplication];
  //  UIView *statusBar = [app valueForKeyPath:@"statusBar"];
    
    id statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    
    NSArray *childrenView ;
    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        childrenView = [[[statusBar valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    } else {
        childrenView = [[statusBar valueForKey:@"foregroundView"] subviews];
    }

    UIView *networkView = nil;
    
    for (UIView *childView in childrenView) {
        if ([childView isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            networkView = childView;
        }
    }
    
    
    
    DYNetworkStatus status = DYNetworkStatusNone;
    if (networkView){
        int type = [[networkView valueForKeyPath:@"dataNetworkType"] intValue];
        switch (type){
            case 0:
                status = DYNetworkStatusNone;
                break;
            case 1:
                status = DYNetworkStatusUnknown;
                break;
            case 2:
                status = DYNetworkStatus3G;
                break;
            case 3:
                status = DYNetworkStatus4G;
                break;
            case 5:
                status = DYNetworkStatusWifi;
                break;
            default:
                status = DYNetworkStatusUnknown;
                break;
        }
    }
    return status;
}



static int pingtest()
{
    struct hostent *url;
    
    url = gethostbyname([hoststring UTF8String]);
    if(url == NULL)
    {
        printf("Pingtest Failed!\n");
        return 0;
    }
    else if(!strcmp("10.10.0.1",inet_ntoa(*((struct in_addr *)url->h_addr))))
    {
        printf("DNS cheat!\n");
        return 0;
    }
    else
    {
        printf("IP Address : %s\n",inet_ntoa(*((struct in_addr *)url->h_addr)));
        printf("Pingtest OK!\n");
        return 1;
    }
}


- (NSDictionary *)networkDict{
    return @{
             @(DYNetworkStatusNone)   : @"无网络",
             @(DYNetworkStatusUnknown) : @"未知网络",
             @(DYNetworkStatus3G)     : @"3G网络",
             @(DYNetworkStatus4G)     : @"4G网络",
             @(DYNetworkStatusWifi)   : @"WIFI网络",
             };
}
@end
