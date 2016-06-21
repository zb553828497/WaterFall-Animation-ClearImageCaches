//
//  DetailViewController.m
//  RedBook
//
//  Created by zhangbin on 16/6/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "DetailViewController.h"
#import "Masonry.h"
#import "ShopModel.h"
#import "UIImageView+WebCache.h"


@interface DetailViewController ()
/** 经过等比例计算过的大商品图片的frame*/
@property(nonatomic,assign)CGRect desImageViewRect;
/** 用户头像*/
@property(nonatomic,weak)UIImageView *avatarImageView;
/** 用户昵称*/
@property(nonatomic,weak)UILabel *nameB;
/** "关注"按钮*/
@property(nonatomic,weak)UIButton* followButton;
/** 商品图片的描述*/
@property(nonatomic,weak)UILabel* contentLB;
/** 商品图片*/
@property(nonatomic,weak)UIImageView *contentImageView;
/** scrollView*/
@property(nonatomic,weak)UIScrollView *scrollView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
// model是当前的小格子模型，这一个小格子模型就包括模型中的所有属性。因为一个小格子就包括plist中所有key
-(instancetype)initWithShopModel:(ShopModel *)model desImageViewRect:(CGRect)desRect{
    self = [super init];
    if (self != nil) {
        // 存储商品图片的frame，这个frame的宽高是经过等比例计算过的大图
        self.desImageViewRect = desRect;
        [self setUpMain];
        // 调用model的setter方法，用来设置数据到DetailViewController控制器中
        // 注意:必须声明一个Model类型的属性，这样self.model = model;才不会报错。声明的Model类型的属性写在.h或者.m文件都可以
        self.model = model;
    }
    return  self;
}
-(void)setUpMain{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1000);
    // scrollView添加到当前类的控制器中
    [self.view addSubview:scrollView];
    // 滚动的范围(左右可滚动一个屏幕的宽度,上下可滚动1000的高度)
    self.scrollView = scrollView;
    // 用户头像
    UIImageView *avatarImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 64+5, 40, 40)];
    // 头像的圆角半径为20，也就是头像的宽、高的一半，所以头像变为了圆形
    self.avatarImageView.layer.cornerRadius = 20;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView = avatarImageView;
    // 用户头像添加到scrollView中
    [scrollView addSubview:avatarImageView];
    // 用户昵称
    UILabel *nameB = [[UILabel alloc] init];
    // 昵称的frame的x值为头像的最大x+10
    nameB.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame)+10, 64+20, 0, 0);
    nameB.font = [UIFont systemFontOfSize:15];
    nameB.textColor = [UIColor blackColor];
    self.nameB = nameB;
     // 用户昵称添加到scrollView中
    [scrollView addSubview:nameB];
    
    // "关注"按钮
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = CGRectMake(self.view.bounds.size.width - 70, 0, 60, 25);
    followButton.center = CGPointMake(followButton.center.x, avatarImageView.center.y);
    [followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [followButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.8]];
    followButton.titleLabel.font = [UIFont systemFontOfSize:12];
    // 圆角半径为2
    followButton.layer.cornerRadius = 2;
    followButton.layer.masksToBounds = YES;
    // "关注"按钮添加到scrollView中
    [scrollView addSubview:followButton];
    self.followButton = followButton;
    // 监听"关注"按钮的点击
    [followButton addTarget:self action:@selector(followClick) forControlEvents:UIControlEventTouchUpInside];
   
    // 商品图片
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.frame = self.desImageViewRect;
    contentImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 商品图片添加到scrollView中
    [scrollView addSubview:contentImageView];
    // 商品图片的尺寸就是经过等比例计算过的desImageViewRect
    self.contentImageView = contentImageView;
    // 商品图片的描述
    UILabel *contentLB = [[UILabel alloc]init];
    contentLB.font = [UIFont systemFontOfSize:12];
    contentLB.textColor = [UIColor blackColor];
    // 多行显示
    contentLB.numberOfLines = 0;
    self.contentLB = contentLB;
    // 商品图片的描述添加到scrollView中
    [scrollView addSubview:contentLB];
    // 利用Masonry框架,为商品图片的描述添加约束.有了约束的限制,所以必须满足约束的条件下,才能显示商品的描述
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        // 商品图片的描述的左边等于父控件的左边+10像素
        make.left.mas_equalTo(10);
        // 商品图片的描述的宽度等于父控件scrollView的宽度-20像素，即商品图片的描述比父控件的宽度少20
        make.width.mas_equalTo(scrollView.mas_width).offset(-20);
        // 商品图片的描述的顶部等于等于商品图片contentImageView的底部+15像素
        make.top.mas_equalTo(contentImageView.mas_bottom).offset(15);
    }];
}
-(void)setModel:(ShopModel *)model{
    _model = model;
    // 取出模型中存储的name属性，显示到系统的text属性上
    self.nameB.text = model.name;
    [self.nameB sizeToFit];
    // 取出模型中存储的icon属性，然后下载图片，将头像显示到界面上
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    // 取出模型中存储的des属性，然后显示到系统`text属性上
    self.contentLB.text = model.des;
    [self.contentLB layoutIfNeeded];
    
    // 设置scrollView的滚动范围
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.contentLB.frame)+20);
    // 以下的做法等同于上面的做法，只不过上面的是点语法访问属性，下面的是访问属性的setter方法访问属性
    //    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.contentLB.frame) + 20)];

}
-(void)followClick{
    NSLog(@"关注按钮被点击");
}

/**
 *  实现了ZBAnimation类的代理方法，在代理方法中下载商品图片到指定位置
 */
-(void)didFinishTransition{
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img]];
}
@end
