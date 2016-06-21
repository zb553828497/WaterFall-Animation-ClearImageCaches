
//
//  ZBShopCollectionViewCell.m
//  RedBook
//
//  Created by zhangbin on 16/6/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBShopCollectionViewCell.h"
#import "ShopModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface ZBShopCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *ShopDes;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end


@implementation ZBShopCollectionViewCell

-(void)awakeFromNib{
    [self.ShopDes layoutIfNeeded];
    // 创建黑色View
    UIView* line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    line.alpha = 0.2;
    [self.contentView addSubview:line];
    // 为黑色View添加约束(注意谁调用的mas_makeConstraints:方法，就是为谁添加约束)
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        // 代码块中的如下代码确定了黑色View的 宽+高+位置，所以约束生效
        
        // 黑色View的左边等于父控件的左边
        make.left.mas_equalTo(self.mas_left);
        // 黑色View的右边等于父控件的右边
        make.right.mas_equalTo(self.mas_right);
        // 黑色View的高度等于0.5
        // 利用mas_equalTo，框架的底层自动将()中的参数修改为对象类型，基本数据类型0.5实际被转换成了对象类型@0.5，如果参数本来就是对象类型，框架的底层就不需要转了
        make.height.mas_equalTo(@0.5);
        // 黑色View的顶部等于文字的底部+8，也就是在文字底部偏移8像素的距离
        make.top.mas_equalTo(self.ShopDes.mas_bottom).offset(8);
    }];
    
    self.iconImageView.layer.cornerRadius = 11;
    self.iconImageView.layer.masksToBounds = YES;

}

-(void)setModel:(ShopModel *)model{
    _model = model;
    // 商品图片必须的下载,然后存储到模型中，最后显示到界面上.而昵称和头像不需要下载，直接赋值给系统的属性即可。另外头像也必须下载。
    
    // 下载商品图片，存到模型中，显示图片
    // 为什么能显示?因为self.imageView已经和xib中的UIImageView控件进行了关联，所以下载好了图片，就一定能够显示
    [self.imageView  sd_setImageWithURL:[NSURL URLWithString:model.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 经过下载,得到了商品图片的真实宽度，放到模型的w属性中保存
        model.w = [NSString stringWithFormat:@"%.2f",image.size.width];
        // 经过下载,得到了商品图片的真实高度，放到模型的h属性中保存
        model.h = [NSString stringWithFormat:@"%.2f",image.size.height];
        
    }];
    // 显示昵称
    self.NameLabel.text = model.name;
    // 显示商品图片的描述
    self.ShopDes.text = model.des;
    // 显示头像
    // 为什么能显示?因为self.iconImageView已经和xib中的UIImageView控件进行了关联，所以下载好了图片，一定能够显示
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];

}
@end
