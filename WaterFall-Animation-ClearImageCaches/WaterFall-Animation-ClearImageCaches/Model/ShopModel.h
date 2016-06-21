//
//  ShopModel.h
//  RedBook
//
//  Created by zhangbin on 16/6/14.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShopModel : NSObject
/** 商品图片的真实高度*/
@property (nonatomic, copy) NSString *h;
/** 商品图片的真实宽度*/
@property (nonatomic, copy) NSString *w;
/** 商品图片的url地址*/
@property (nonatomic, copy) NSString *img;
/** 商品图片的描述*/
@property (nonatomic, copy) NSString *des;
/** 用户的昵称*/
@property (nonatomic, copy) NSString *name;
/** 用户的头像*/
@property (nonatomic, copy) NSString *icon;
/** 字典数组转成模型数组*/
+(NSArray*)models;
/** 返回等比例计算出来的商品图片的宽度和高度*/
-(CGSize)scaleSize;// 一定要导入UIKit框架，否则报错



@end
