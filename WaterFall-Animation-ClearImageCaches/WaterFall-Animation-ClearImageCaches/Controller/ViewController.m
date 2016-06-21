//
//  ViewController.m
//  RedBook
//
//  Created by zhangbin on 16/6/14.
//  Copyright © 2016年 zhangbin. All rights reserved.
//


#import "ViewController.h"
#import "ShopModel.h"
#import "ZBShopCollectionViewCell.h"
#import "DetailViewController.h"
#import "ZBNavigationController.h"
#import "ZBWaterFallLayout.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZBWaterFallLayoutDelegate>
@property (nonatomic, weak) UICollectionView* collectionView;
@property(nonatomic,strong)NSArray *array;

@end

static NSString *const ZBShopId = @"cell";
@implementation ViewController

- (NSArray *)array
{
    if (!_array) {
        // 调用models方法，加载1.plist文件中的数据，将加载出来的数据放到modelArray数组中保存
        _array = [ShopModel models];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMain];
    
    
}

- (void)setupMain {
    
    
    ZBWaterFallLayout *layout = [[ZBWaterFallLayout alloc] init];
    // 设置ZBWaterFallLayout的代理为当前控制器
    layout.delegate = self;
    
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [collectionView registerNib:[UINib nibWithNibName:@"ZBShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ZBShopId];
    
    [self.view addSubview:collectionView];
    // 计算缓存
    [self CalCaches];
    // 定时器，用于实时监测缓存
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(AgainCalCaches) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}
-(void)CalCaches{
    // 字节大小
    NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;
    // M大小
    double size = byteSize / 1000.0 / 1000.0;
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小(%.1fM)", size];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:0 target:self action:@selector(clearCache)];
    
    //  [self fileOperation];
    
    
    
}
-(void)AgainCalCaches{
    
    [self CalCaches];
}

- (void)clearCache
{
    // 点击清除缓存的时候,让"清除缓存"按钮变为菊花
    UIActivityIndicatorView *circle = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [circle startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:circle];
    // 清除图片缓存.注意:无法清除音频，视频缓存
    [[SDImageCache sharedImageCache] clearDisk];
    // 上述清除图片缓存之后，图片缓存肯定不存在了，我们把navigationItem的标题设置为0,方便提醒用户
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小(0.0M)"];
}



#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
/** 一组*/
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/** 小格子的个数*/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
/** 显示每一个小格子*/
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZBShopCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZBShopId forIndexPath:indexPath];
    
    cell.model = self.array[indexPath.item];
    
    
    return cell;
}

/** 点击每一个小格子就会调用*/
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopModel* model = self.array[indexPath.item];
    
    ZBShopCollectionViewCell* cell = (ZBShopCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    // 详情页中，让商品图片等于屏幕的宽度，再经过等比例计算，得到商品图片的高度
    CGRect desImageViewRect = CGRectMake(0, 60 + 64, [model scaleSize].width, [model scaleSize].height);
    //  两个参数:商品的模型对象、大的商品图片
    DetailViewController* vc = [[DetailViewController alloc] initWithShopModel:model desImageViewRect:desImageViewRect];
    // 以动画的形式push至DetailViewController控制器。
    // 具体怎么push的，查看pushViewController:withImageView:desRect方法中的具体实现代码即可
    [((ZBNavigationController *) self.navigationController) pushViewController:vc WithImageView:cell.imageView desRect:desImageViewRect delegate:vc];
}

#pragma mark ZBWaterFallLayoutDelegate
-(CGFloat)WaterFallLayout:(ZBWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index ItemWidth:(CGFloat)itemWidth{
    ShopModel *EveryModel = self.array[index];
    
    CGFloat scale = [EveryModel.w floatValue] / itemWidth;
    // 等比例求出来的是商品图片的高度，必须得加上110(图片下面的内容:图片描述，用户昵称，用户头像，关注)得到的高度才是小格子的总高度。如果不加上110，商品图片还得分出来110的高度给图片下面的内容
    // 等比例计算出来的高度为什么是商品图片的高度？因为，EveryModel.w 中的w就是图片的宽度。EveryModel.h中的h也是图片的高度，操作的都是图片
    CGFloat height = [EveryModel.h floatValue] / scale + 110;
    return height;
    
}

// 行间距
-(CGFloat)RowMarginInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return 15;
}
-(CGFloat)ColumnMarginInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return 15;
}
// 列数
-(CGFloat)ColumnCountInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return 2;
}

// edge
-(UIEdgeInsets)EdgeInsetsInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end

