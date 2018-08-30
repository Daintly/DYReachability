//
//  DYNetNofication.h
//  DYReachability
//
//  Created by Dainty on 2018/9/1.
//  Copyright © 2018年 Dainty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 *  定义一个网络状态的全局通知
 */
extern NSString *const DYReachabilityChangeNotification;

typedef NS_ENUM(NSInteger ,DYNetworkStatus){
    DYNetworkStatusNone           = 0 ,
     DYNetworkStatusUnknown       = 1 ,
    DYNetworkStatus3G             = 2 ,
    DYNetworkStatus4G             = 3 ,
    DYNetworkStatusWifi           = 4

};

@protocol DYNetNoficationDelegate <NSObject>

- (void)host:(NSString *)host networkStatusDidChanged:(DYNetworkStatus)status;
@end
@interface DYNetNofication : NSObject
@property (nonatomic ,assign) DYNetworkStatus networkStatus;
@property (nonatomic, weak) id <DYNetNoficationDelegate>delegate;
/*
 *默认www.baidu.com
 */
+ (instancetype)defultNotification;

- (void)startNotification;
- (void)stopNotification;
@end
