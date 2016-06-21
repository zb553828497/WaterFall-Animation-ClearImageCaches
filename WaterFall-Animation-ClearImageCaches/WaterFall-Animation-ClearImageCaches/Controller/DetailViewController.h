//
//  DetailViewController.h
//  RedBook
//
//  Created by zhangbin on 16/6/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBAnimation.h"
@class ShopModel;
@interface DetailViewController : UIViewController<ZBAnimationDelegate>

-(instancetype)initWithShopModel:(ShopModel *)model desImageViewRect:(CGRect)desRect;
// 拿到模型类
@property(nonatomic,strong)ShopModel *model;
@end
