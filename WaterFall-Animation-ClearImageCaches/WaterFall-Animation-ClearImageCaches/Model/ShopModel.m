//
//  ShopModel.m
//  RedBook
//
//  Created by zhangbin on 16/6/14.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
/** 字典数组转成模型数组*/
+(NSArray *)models{
    NSMutableArray* array = [NSMutableArray array];
    
    NSArray* dicArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
    
    for (NSDictionary* dic in dicArray) {
        ShopModel* m = [ShopModel new];
        [m setValuesForKeysWithDictionary:dic];
        [array addObject:m];
    }
    
    return array;
}
/** 返回等比例计算出来的商品图片的宽度和高度*/
-(CGSize)scaleSize{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 缩放比例 = 屏幕宽度 / 商品图片的真实宽度
    CGFloat scale = width / [self.w floatValue];
    //   根据比例计算出来的商品图片在屏幕中的高度 = 商品图片的真实高度 / 缩放比例
    CGFloat height = [self.h floatValue] * scale;
    // 根据等比例计算，返回图片的真实宽度等于屏幕宽度情况时，屏幕的高度。这样就保证了图片是等比例缩放的，也能够让商品图片最大限度的显示在手机屏幕上
    return CGSizeMake(width, height);
}

@end
