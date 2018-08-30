//
//  ViewController.m
//  DYReachability
//
//  Created by Dainty on 2018/9/1.
//  Copyright © 2018年 Dainty. All rights reserved.
//

#import "ViewController.h"
#import "DYNetNofication.h"
@interface ViewController ()
@property (nonatomic, strong)DYNetNofication *nettion;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.nettion = [DYNetNofication defultNotification];
    [self.nettion startNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
