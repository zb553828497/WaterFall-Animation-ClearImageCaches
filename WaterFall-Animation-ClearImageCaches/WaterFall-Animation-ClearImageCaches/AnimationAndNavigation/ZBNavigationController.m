//
//  ZBNavigationController.m
//  RedBook
//
//  Created by zhangbin on 16/6/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBNavigationController.h"

@interface ZBNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, assign) CGRect origionRect;
@property (nonatomic, assign) CGRect desRect;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, weak) id  animationDelegate;
@end

@implementation ZBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}
/**
 *  @param viewController 要跳转到的目标控制器
 *  @param imageView      小图片
 *  @param desRect        大图片在目标控制器中的frame
 *  @param delegate       目标控制器遵守了ZBAnimationDelegate协议,若要执行代理方法，必须给代理属性赋值
 */
- (void)pushViewController:(UIViewController *)viewController WithImageView:(UIImageView *)imageView desRect:(CGRect)desRect delegate:(id<ZBAnimationDelegate>)delegate{
    
    self.delegate=self;
    // 用全局变量self.imageView保存imageView中的商品图片。
    // imageView就是ViewController.m文件中的cell.imageView, cell.imageView就是ZBShopCollectionViewCell.h文件中的imageView属性。因为imageView属性已经和xib中的UIImageView控件进行了关联,并且ZBShopCollectionViewCell.m文件已经通过SDWebImage框架下载好了文件到self.imageView，所以imageView属性已经存储了下载好的商品图片。
    // 强烈注意:这个imageView是小图片,就是ViewController中的图片，这个图片就是xib中的小图片
    self.imageView = imageView;
    // 转换坐标系 将小图片imageView的坐标改为相对于当前导航控制器的view中的坐标   为什么要转换坐标系？
    // origionRect还是指的小图片，只不过坐标系(x,y)转换了，自身的宽高不变，所以frame中的前两个参数变化，后面两个参数不变
    self.origionRect = [imageView convertRect:imageView.frame toView:self.view];
    // 用全局变量self.desRect保存等比例计算好的商品图片的frame
    // desRect就是viewController.m文件中的desImageViewRect
    // 强烈注意:desRect代表的frame是大图片，也就是详情控制器DetailViewController中的图片
    self.desRect = desRect;
    // 用全局变量self.isPush保存YES，用于记录当前正在push
    self.isPush = YES;
    // 用全局变量self.animationDelegate保存代理对象delegate.
    // delegate就是ViewController.m文件中的vc. vc就是DetailViewController控制器的对象。
    self.animationDelegate = delegate;
    // push操作. viewController就是ViewController.m文件中的vc，vc就是DetailViewController控制器
    [super pushViewController:viewController animated:YES];
}

// 点击导航栏左侧的Back按钮就会执行pop操作
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    self.isPush = NO;
    return  [super popViewControllerAnimated:animated];
}

#pragma mark - UINavigationControllerDelegate
// UINavigationController自带的协议接口。ZBNavigationController通过遵守协议，来实现代理方法
//当进行push/pop控制器的过程中，一定会调用重写的这个方法。
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    ZBAnimation* animation = [[ZBAnimation alloc] init];
    // 取出全局变量self.imageView保存的商品图片,赋值给OUNavAnimation类的imageView对象保存。
    animation.imageView = self.imageView;
    // 取出全局变量self.origionRect保存的转换坐标系的坐标,赋值给OUNavAnimation类的origionRect对象保存。
    animation.origionRect = self.origionRect;
    // 取出全局变量self.desRect等比例计算好的商品图片的frame,赋值给OUNavAnimation类的desRect对象保存。
    animation.desRect = self.desRect;
    // 取出全局变量self.isPush保存的YES，赋值给OUNavAnimation类的isPush对象保存
    animation.isPush = self.isPush;
    // 取出全局变量self.animationDelegate保存的代理对象delegate,也就是vc,赋值给OUNavAnimation类的delegate对象保存.
    // 也就是让DetailViewController类的对象成为OUNavAnimation类的对象的代理。如果DetailViewController类实现了代理方法，就执行代理方法
    animation.delegate = self.animationDelegate;
    if (!self.isPush && self.animationDelegate) {
        self.delegate = nil;
    }
    return animation;
}
@end
