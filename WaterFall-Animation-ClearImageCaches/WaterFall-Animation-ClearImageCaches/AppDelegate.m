//
//  AppDelegate.m
//  WaterFall-Animation-ClearImageCaches
//
//  Created by zhangbin on 16/6/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZBNavigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    ViewController *main = [[ViewController alloc] init];
    ZBNavigationController *nav = [[ZBNavigationController alloc]initWithRootViewController:main];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible ];
    return YES;
}
@end