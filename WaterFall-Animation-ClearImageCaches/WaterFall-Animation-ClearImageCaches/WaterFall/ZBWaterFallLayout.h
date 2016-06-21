//
//  ZBWaterFallLayout.h
//  WaterFall
//
//  Created by zhangbin on 16/6/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBWaterFallLayout;

@protocol ZBWaterFallLayoutDelegate <NSObject>

@required
-(CGFloat)WaterFallLayout:(ZBWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index ItemWidth:(CGFloat)itemWidth;

@optional
-(CGFloat)ColumnCountInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout;
-(CGFloat)ColumnMarginInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout;
-(CGFloat)RowMarginInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout;
-(UIEdgeInsets)EdgeInsetsInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout;

@end

@interface ZBWaterFallLayout : UICollectionViewLayout

@property(nonatomic,weak)id<ZBWaterFallLayoutDelegate> delegate;

@end
