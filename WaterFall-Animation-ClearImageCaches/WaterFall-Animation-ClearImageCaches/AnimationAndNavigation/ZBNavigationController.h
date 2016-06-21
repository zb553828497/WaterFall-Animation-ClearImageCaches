//
//  ZBNavigationController.h
//  RedBook
//
//  Created by zhangbin on 16/6/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBAnimation.h"
@interface ZBNavigationController : UINavigationController

-(void)pushViewController:(UIViewController *)viewController WithImageView:(UIImageView*)imageView desRect:(CGRect)desRect delegate:(id <ZBAnimationDelegate>) delegate;

@end
