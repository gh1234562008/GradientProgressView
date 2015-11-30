//
//  CustomView.m
//  ProgressView
//
//  Created by sxiaojian on 15/11/9.
//  Copyright © 2015年 sxiaojian. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
-(void)awakeFromNib{
    [self drawRect:self.bounds];
}
- (void)drawRect:(CGRect)rect{
    UIColor *beginColor = [UIColor whiteColor];
    UIColor *endColor   = [UIColor redColor];
    CGFloat beginR;
    CGFloat beginG;
    CGFloat beginB;
    CGFloat endR;
    CGFloat endG;
    CGFloat endB;
    [beginColor getRed:&beginR green:&beginG blue:&beginB alpha:nil];
    [endColor getRed:&endR green:&endG blue:&endB alpha:nil];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setFill];
    UIRectFill(CGRectMake(0, 0, 1, 1));
    
    int sectors = 360;
    float radius = MIN(100, 100)/2;
    float angle = 2 * M_PI/sectors;
    UIBezierPath *bezierPath;
    
    for (int i = 0; i < sectors; i++)
    {
        CGFloat ratio = (float)i / (float)sectors ;
        CGFloat R = beginR + (endR - beginR) * ratio ;
        CGFloat G = beginG + (endG - beginG) * ratio ;
        CGFloat B = beginB + (endB - beginB) * ratio ;
        CGPoint center = CGPointMake(55, 55);
        bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:i * angle endAngle:(i + 1) * angle clockwise:YES];
        UIColor *color = [UIColor colorWithRed:R green:G blue:B alpha:1];
        [bezierPath setLineWidth:3];
        [color setStroke];

        [bezierPath stroke];
    }
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
