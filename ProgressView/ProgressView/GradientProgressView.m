//
//  GradientProgressView.h
//  ProgressView
//
//  Created by sxiaojian on 15/10/29.
//  Copyright © 2015年 sxiaojian. All rights reserved.
//

#import "GradientProgressView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface GradientProgressView ()
{
    CGFloat beginR;
    CGFloat beginG;
    CGFloat beginB;
    CGFloat endR;
    CGFloat endG;
    CGFloat endB;
}
@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic, assign) CGFloat backgroundRingWidth;
@property (nonatomic, assign) CGFloat progressRingWidth;

@property (nonatomic, assign) CGFloat animationFromValue;
@property (nonatomic, assign) CGFloat animationToValue;
@property (nonatomic, assign) CFTimeInterval animationStartTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *trackPointLayer;

@property (nonatomic) CGFloat realTimeProgress;
@property (nonatomic, assign) CGFloat moveSpeed;
@end

@implementation GradientProgressView

#pragma mark - Initializers -

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Initialize -

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    _moveSpeed = 0.2;
    _trackTintColor = [UIColor colorWithWhite:1 alpha:0.05f];

    
    [[UIColor yellowColor] getRed:&beginR green:&beginG blue:&beginB alpha:nil];
    [[UIColor redColor] getRed:&endR green:&endG blue:&endB alpha:nil];

    _backgroundRingWidth = 10.0f;
    _progressRingWidth = 10.0f;
    _animationDuration = 0.3f;

    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundLayer.strokeColor = _trackTintColor.CGColor;
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = _backgroundRingWidth;
    [self.layer addSublayer:_backgroundLayer];
    
    _trackPointLayer = [CAShapeLayer layer];
    _trackPointLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    [self.layer addSublayer:_trackPointLayer];
    
}

#pragma mark - Override super methods -

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    [self drawBackground];
    [self drawProgress];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundLayer.frame = self.bounds;

    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width;
    }
    [super setFrame:frame];
}

#pragma mark - Intrinsic content size for AutoLayout -

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark - Getters and setters -

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    if (_trackTintColor != trackTintColor) {
        _trackTintColor = trackTintColor;
        _backgroundLayer.strokeColor = trackTintColor.CGColor;
        [self setNeedsDisplay];
    }
}

- (void)setBackgroundRingWidth:(CGFloat)backgroundRingWidth
{
    _backgroundRingWidth = backgroundRingWidth;
    _backgroundLayer.lineWidth = _backgroundRingWidth;
    [self setNeedsDisplay];
}

- (void)setProgressRingWidth:(CGFloat)progressRingWidth
{
    _progressRingWidth = progressRingWidth;
    [self setNeedsDisplay];
}

- (void)setAnimationDuration:(CGFloat)animationDuration
{
    _animationDuration = animationDuration;
}
#pragma mark - Progress -

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    
    if (self.progress == progress) {
        return;
    }
    _animationDuration = fabs(self.progress - progress) / _moveSpeed;
    
    if (animated == NO) {
        if (_displayLink) {
            [_displayLink invalidate];
            _displayLink = nil;
        }
        _progress = progress;
        _realTimeProgress = progress;
        [self setNeedsDisplay];
    } else {
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue = progress;
        _progress = progress;
        _realTimeProgress = 0;
        if (!_displayLink) {
            [self.displayLink invalidate];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        }
    }
}

#pragma mark - Private methods -

- (void)animateIndeterminate:(NSTimer *)timer
{
    CGAffineTransform transform = CGAffineTransformRotate(self.transform, 0.05);
    self.transform = transform;
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - _animationStartTime) / self.animationDuration;
        if (dt >= 1.0) {
            [self.displayLink invalidate];
            self.displayLink = nil;
            _realTimeProgress = _animationToValue;
            [self setNeedsDisplay];
            return;
        }

        _realTimeProgress = _animationFromValue + dt * (_animationToValue - _animationFromValue);
        [self setNeedsDisplay];
    });
}

- (void)drawBackground
{
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = startAngle + (2.0 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundRingWidth) / 2.0;

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = _progressRingWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

    _backgroundLayer.path = path.CGPath;
    
}

- (void)drawProgress
{
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = startAngle + (2.0 * M_PI * _realTimeProgress );
    CGFloat trackPointEndAngle = startAngle + (2.0 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _progressRingWidth) / 2.0;
    
    int sectors = 80;
    float angle ;
    
    CGFloat startAngleNeedDraw ;

    if (endAngle - startAngle >  2.0 * M_PI) {
        angle = 2 * M_PI/sectors;
        startAngleNeedDraw = endAngle - 2.0 * M_PI;

    } else {
        angle = (endAngle - startAngle) / sectors;
        startAngleNeedDraw = startAngle;

    }

    UIBezierPath *sectorPath;
    for (int i = 0; i < sectors; i ++) {
        CGFloat ratio = (float)i / (float)sectors ;
        CGFloat R = beginR + (endR - beginR) * ratio ;
        CGFloat G = beginG + (endG - beginG) * ratio ;
        CGFloat B = beginB + (endB - beginB) * ratio ;

        sectorPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngleNeedDraw + i * angle endAngle:startAngleNeedDraw + (i + 1) * angle + 0.001 clockwise:YES];
        if (i == 0) {
            sectorPath.lineCapStyle = kCGLineCapRound;
        }
        UIColor *color = [UIColor colorWithRed:R green:G blue:B alpha:1];
        [sectorPath setLineWidth:_progressRingWidth];
        [sectorPath setLineCapStyle:kCGLineCapRound];
        [color setStroke];
        
        [sectorPath stroke];
    }
    
    if (endAngle != startAngle ) {
        CGSize shadowOffset = CGSizeMake(0, 3);
        CGAffineTransform transform = CGAffineTransformMakeRotation(endAngle);
        CGSize newOffset = CGSizeApplyAffineTransform(shadowOffset, transform);
        
        NSShadow* shadow = [[NSShadow alloc] init];
        [shadow setShadowColor: [UIColor colorWithWhite:0 alpha:0.4]];
        [shadow setShadowOffset: newOffset];
        [shadow setShadowBlurRadius: 1];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        sectorPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:endAngle - angle endAngle:endAngle clockwise:YES];
        CGContextSaveGState(context);
        
        UIColor *color = [UIColor colorWithRed:endR green:endG blue:endB alpha:1];
        [sectorPath setLineWidth:_progressRingWidth];
        [sectorPath setLineCapStyle:kCGLineCapRound];
        
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
        [color setStroke];
        [sectorPath stroke];
        
        CGContextRestoreGState(context);
    }

    UIBezierPath *circularPath = [UIBezierPath bezierPath];
    [circularPath addArcWithCenter:sectorPath.currentPoint radius:_progressRingWidth/2 - 3 startAngle:startAngle endAngle:trackPointEndAngle clockwise:YES];
    _trackPointLayer.path = circularPath.CGPath;
    

    
}

@end
