//
//  ZBAnimation.h
//  RedBook
//
//  Created by zhangbin on 16/6/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZBAnimationDelegate <NSObject>

-(void)didFinishTransition;

@end

@interface ZBAnimation : NSObject
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, assign) CGRect origionRect;
@property (nonatomic, assign) CGRect desRect;
@property (nonatomic, assign) BOOL isPush;
@property(nonatomic,weak)id<ZBAnimationDelegate> delegate;
@end
