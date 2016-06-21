//
//  ZBShopCollectionViewCell.h
//  RedBook
//
//  Created by zhangbin on 16/6/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;

@interface ZBShopCollectionViewCell : UICollectionViewCell
/** 拿到Model模型中的所有属性*/
@property (nonatomic, strong) ShopModel* model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
