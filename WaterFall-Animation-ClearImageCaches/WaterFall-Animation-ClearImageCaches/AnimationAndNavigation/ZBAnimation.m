
//
//  ZBAnimation.m
//  RedBook
//
//  Created by zhangbin on 16/6/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBAnimation.h"
@interface ZBAnimation()<UIViewControllerAnimatedTransitioning>
// 声明一个遵守UIViewControllerContextTransitioning协议的一个属性。只有遵守了UIViewControllerContextTransitioning协议，才能实现对应的方法.
// 为什么UIViewControllerContextTransitioning不写在类扩展的后面，而是声明了一个遵守该协议的属性？
// 答:如果写在类扩展后面，那么必须实现很多个方法，如果不实现就会提示警告,而通过下面这中形式不会提示这些警告
@property(nonatomic,weak)id<UIViewControllerContextTransitioning>ZBtransitionContext;
@end
@implementation ZBAnimation
// 在类扩展中声明了一个自定义的属性(必须遵守指定的协议)，就会调用系统的transitionDuration:方法
// 当push/pop控制器时,导航条上的Back按钮经过0.5秒出现/0.5秒消失
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)ZBtransitionContext{
    return 0.5;
}
// 在类扩展中声明了一个自定义的属性(必须遵守指定的协议)，就会调用系统的animateTransition:方法
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)ZBtransitionContext{
    UIView *contentView = [ZBtransitionContext containerView];
    contentView.backgroundColor = [UIColor whiteColor];
    UIViewController *ToVc = [ZBtransitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ToVc.view.alpha = 0;
     // imageView指的是转换坐标系之后的图片
    __block UIImageView *imageView = [[UIImageView alloc]initWithImage:
                                      self.imageView.image];
    
    // 技巧:两个animateWithDuration相辅相成。
    //两者相结合的效果:push时,第一个动画拿到小图片，用0.2秒的时间显示小图片，第二个动画拿到大图片，用0.3秒的时间让小图片放大为大图片. pop视,第一个动画拿到大图片，用0.2秒的时间显示大图片，第二个动画拿到小图片，用0.3秒的时间让大图片缩小为小图片。 同一时间点内，只能为push和pop中的一个，所以push时并不会受到pop的干扰，pop时也不会收到push的干扰
    
    
    // 0.2秒的时间: 如果是push,拿到小图片的frame，利用动画效果让小图片由隐藏到显示
    // 0.2秒的时间: 如果是pop, 拿到大图片的frame，利用动画效果让大图片由隐藏到显示
    imageView.frame = self.isPush? self.origionRect:self.desRect;
    NSLog(@"%@",NSStringFromCGRect(imageView.frame));
    imageView.backgroundColor = self.imageView.backgroundColor;
    
    [contentView addSubview:ToVc.view];
    [contentView addSubview:imageView];
    [UIView animateWithDuration:0.2 animations:^{
        ToVc.view.alpha = 1.0f;
    }];
    
    
    UIImage *image = nil;
    // 正在执行pop到ViewController界面,就执行{}
    // 不可删除,如果删除了这段代码，pop控制器时，点击的小格子上的商品图片将会消失不见，只有将这个小格子滚动到看不见的位置，然后再滚动到这个小格子的位置时，这个商品图片才会再次出现
    // 现在是pop过来的ViewController控制器，就把之前的小图片copy一份显示到之前的位置上
    if (!self.isPush) {
        image = [self.imageView.image copy];
        self.imageView.image = nil;
    }
    // 0.3秒的时间:如果是push,拿到大图片frame,让小图片经过0.3秒放大到大图片的desRect上
    // 0.4秒的时间:如果是pop,，拿到小图片的frame,让大图片0.3秒缩小到小图片的origionRect上
    [UIView animateWithDuration:2.3 animations:^{
        imageView.frame = self.isPush ? self.desRect : self.origionRect;
    } completion:^(BOOL finished) {// 动画完成时执行{}
        // 查看项目中有没有代理实现didFinishTransition方法，有的话，再判断是否是push，两者都满足就执行didFinishTransition方法中的内容，在内容中，下载图片，这个图片是大图片哦
        if ([self.delegate respondsToSelector:@selector(didFinishTransition)] && self.isPush) {
            [self.delegate didFinishTransition];
        }
        [ZBtransitionContext completeTransition:YES];
        // 将imageView从父控件UIView上移除
        [imageView removeFromSuperview];
        // 如果不是push，即肯定是pop。此时就是在ViewController中，所以就将image显示到小图片上
        // 注意:这个image还是之前的小图片，不是放大之后的图片。因为放大的图片和image没有任何关系
        // 已经pop到ViewController界面 就执行{}
        if (!self.isPush) {
            self.imageView.image = image;
            NSLog(@"%@",NSStringFromCGRect(self.imageView.frame));
        }
        // 清空指针
        imageView = nil;
    }];
    
}
@end
