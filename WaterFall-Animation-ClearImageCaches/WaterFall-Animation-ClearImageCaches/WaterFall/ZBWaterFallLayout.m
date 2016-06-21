//
//  ZBWaterFallLayout.m
//  WaterFall
//
//  Created by zhangbin on 16/6/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBWaterFallLayout.h"


/** 默认的列数*/
// 不要写在类扩展里面，否则会报错
static const NSInteger ZBDefaultColumnCount = 3;// 改为1就变成了UITableView
/** 默认每一列之间的间距*/
static const NSInteger ZBDefaultColumnMargin = 10;
/** 默认每一行之间的间距*/
static const NSInteger ZBDefaultRowMargin = 10;
/** 距离屏幕边缘的间距*/
static const UIEdgeInsets ZBDefaultEdgeInsets = {10,10,10,10};

@interface ZBWaterFallLayout()

@property (nonatomic, assign) BOOL isAutoContentSize;

/** 存放所有列的当前高度 */
@property(nonatomic,strong)NSMutableArray *columnHeights;
/** 存放所有小格子的布局属性 */
@property(nonatomic,strong)NSMutableArray *attrsArray;

/** 行间距*/
@property(nonatomic,assign)CGFloat rowMargin;
/** 列间距*/
@property(nonatomic,assign)CGFloat columnMargin;
/** 每一行小格子的个数*/
@property(nonatomic,assign)NSInteger columnCount;
/** 小格子距离屏幕的上左下右的距离*/
@property(nonatomic,assign)UIEdgeInsets edgeInsets;
@end

@implementation ZBWaterFallLayout

-(NSMutableArray *)columnHeights{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
-(NSMutableArray *)attrsArray{
    if(_attrsArray == nil){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;

}
// 小格子的行间距由代理(ViewController)决定，代理只要实现了RowMarginInWaterFallLayout:方法，并在方法中返回一个数(例如20)，那么声明代理方法的当前类(ZBWaterFallLayout)就能拿到这个20，把代理方法返回过来的20作为当前类的行间距，来计算每一行小格子的间距
-(CGFloat)rowMargin{
    // 优先使用代理设置的数据，如果代理没有通过代理方法设置数据，就使用当前类默认设置的数据
    if([self.delegate respondsToSelector:@selector(RowMarginInWaterFallLayout:)]){
        return [self.delegate RowMarginInWaterFallLayout:self];
    }else{
        return ZBDefaultRowMargin;
    }
}
// 小格子的列间距由代理(ViewController)决定，代理只要实现了ColumnMarginInWaterFallLayout:方法，并在代理方法中返回一个数(例如10)，那么声明代理方法的当前类(ZBWaterFallLayout)就能拿到这个10，把代理方法返回过来的30作为当前类的列间距，来计算每一列小格子的间距
-(CGFloat)columnMargin{
    // 优先使用代理设置的数据，如果代理没有通过代理方法设置数据，就使用当前类默认设置的数据
    if([self.delegate respondsToSelector:@selector(ColumnMarginInWaterFallLayout:)]){
        return [self.delegate ColumnMarginInWaterFallLayout:self];
    }else{
        return ZBDefaultColumnMargin;
    }
}
// 每一行小格子的数量由代理(ViewController)决定，代理只要实现了ColumnCountInWaterFallLayout:方法，并在代理方法中返回一个数字(例如3),那么声明代理方法的当前类(ZBWaterFallLayout)就能拿到这个3，把代理方法返回过来的3作为每一行小格子的数量
-(NSInteger)columnCount{
    // 优先使用代理设置的数据，如果代理没有通过代理方法设置数据，就使用当前类默认设置的数据
    if ([self.delegate respondsToSelector:@selector(ColumnCountInWaterFallLayout:)]) {
        return   [self.delegate ColumnCountInWaterFallLayout:self];
    }else{
        return  ZBDefaultColumnCount;
    }
}
// 小格子距离上左下右的距离由代理(ViewController)决定，代理只要实现了EdgeInsetsInWaterFallLayout:方法，并在代理方法中返回一个UIEdgeInsets类型数据(10, 20, 30, 100)，那么声明代理方法的当前类(ZBWaterFallLayout)就能拿到这个(10, 20, 30, 100)，把代理方法返回过来的(10, 20, 30, 100)作为小格子上左下右的距离，声明代理方法的当前类，只需要访问top, left, bottom, right中的其中一个属性，就能够设置小格子距离屏幕的上部/左部/下部/右部的距离

-(UIEdgeInsets)edgeInsets{
    // 优先使用代理设置的数据，如果代理没有通过代理方法设置数据，就使用当前类默认设置的数据
    if ([self.delegate respondsToSelector:@selector(EdgeInsetsInWaterFallLayout:)]) {
        return [self.delegate EdgeInsetsInWaterFallLayout:self];
    }else{
        return ZBDefaultEdgeInsets;
    }
}


/**
 * 1.初始化
 */
-(void)prepareLayout{
    [super prepareLayout];
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnMargin; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    // 创建每一个小格子对应的布局属性    count为50. 0表示第0组，即1组.只能为0，否则报错
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for(NSInteger i = 0;i < count;i++){
    // 创建位置(第0组的第i个indexPath)
    NSIndexPath *indexPath  = [NSIndexPath indexPathForItem:i inSection:0];
    // 获取indexPath位置上小格子(item)对应的布局属性.一共50个indexPath，所以attrsArray数组中一共装了50个小格子
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 2.决定小格子如何排列
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;

}
/**
 * 3.返回indexPath位置上的小格子对应的布局属性。即计算每一个小格子的位置就会调用，如果有50个小格子，那么就调用50次,
 *   每次调用，一个小格子将会显示在3列中的最短列中。如果这次调用这个方法，小格子显示在最短列中,那么这个最短列的高度将
 *   增加,下次再调用时候，之前的最短列的高度变化了，这时，再重新比较三列中高度最短的那一列,又会把新的小格子显示在新的最
 *   短列中，同样，最短列高度仍然会增加(因为添加了小格子在最短列中)
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // 设置布局属性的frame
    // indexPath位置上的小格子的宽度 = (collectionView的宽度 - 左边缘 - 右边缘 - 中间的间距) / 列数
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin )/ self.columnCount ;
     // indexPath位置上的小格子的高度
    // CGFloat h = 50 + arc4random_uniform(100);//   50 < h的范围 < 150
   
    // indexPath位置上的小格子的高度 = 调用代理方法，并将indexPath.item,w作为参数.代理方法根据indexPath.item得到当前要计算的是哪个小格子，代理方法根据w并利用交叉相成来等比例计算indexPath.item这个小格子的的高度，然后返回给h保存
    CGFloat h = [self.delegate WaterFallLayout:self heightForItemAtIndex:indexPath.item ItemWidth:w];
    
    // 以下代码是找出高度最短的那一列.注意:MinHeightAtColumn表示:计算每一列中的所有小格子的总高度，取高度最小的那一列最为最小高度。目的:为了计算小格子的y坐标。小格子的y坐标=最小高度
    
    // 用下标记录最短列
    NSInteger ShortestColumn = 0;
    // 假设先让第0列高度最短。目的:少遍历一次。遍历次数越少，说明优化的好嘛
    // 第0列的总高度=这一列中所有的小格子的总高度+这一列中所有小格子的间距
    CGFloat MinHeightAtColumn = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        // 如果MinHeightAtColumn的高度大于第i列的高度，就把第i列的高度变为最小高度
        if (MinHeightAtColumn > columnHeight) {
            MinHeightAtColumn = columnHeight;
            // 记录最短列的下标
            ShortestColumn = i;
        }
    }
    // 计算indexPath位置上的小格子要显示在最短列时，小格子的x坐标
    // x = 左间距 + 高度最小的那一列的列号 * (小格子的宽度 + 列间距)
    CGFloat x = self.edgeInsets.left + ShortestColumn * (w + self.columnMargin);
    // 计算indexPath位置上的小格子要显示在最短列时，小格子的y坐标
    CGFloat y = MinHeightAtColumn;//  y = 某列中所有小格子的最短高度
    // 如果是y坐标不等于顶部间距10，那么说明这一行不是第0行，就让这一行的y坐标=行间距+这一行的y坐标。
    // 如果y坐标 = 顶部间距间距10，那么说明这一行是第0行，那么第0行的y坐标 = 10
    if (y != self.edgeInsets.top) {
        y+= self.rowMargin;
    }
    // indexPath位置上的小格子的frame
    attrs.frame = CGRectMake(x, y, w, h);
    // 更新最短那列的高度(即把这个小格子添加到最短列中)
    self.columnHeights[ShortestColumn] = @(CGRectGetMaxY(attrs.frame));
    return attrs;
}

/**
 * 4.滚动的内容尺寸(通过for循环找出高度最高的那一列来决定滚动的范围)
 */
-(CGSize)collectionViewContentSize{
    CGFloat MaxHeightAtColumn = [self.columnHeights[0] doubleValue];
    // 找出高度最高的那一列。目的:确定滚动范围最高滚动到哪里。如果找高度最短的那一列，那么高度最高的那一列就滚动不到了。
    for (NSInteger i = 0; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if(MaxHeightAtColumn < columnHeight){
            MaxHeightAtColumn = columnHeight;
        }
    }
    // 滚动的宽度为0，滚动的高度为MaxHeightAtColumn + self.edgeInsets.bottom)
    return CGSizeMake(0, MaxHeightAtColumn + self.edgeInsets.bottom);

}

//-(void)autuContentSize{
//    self.isAutoContentSize = YES;
//}

@end
