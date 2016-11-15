//
//  UIView+kit.m
//  TwoTableLinkage
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "UIView+kit.h"

@implementation UIView (kit)


- (void)addCornerRadiusWithcorners:(UIRectCorner)corners AndRadii:(CGSize)radii {
    //贝塞尔曲线,创建基于矢量的路径,可以画出椭圆,矩形,曲线等
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    //类工厂方法，但是可以指定某一个角画成圆角
    //CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类 可以不需要管理内存
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.path = bezierPath.CGPath;
    self.layer.mask = shapLayer;
}


@end
