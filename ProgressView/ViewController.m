//
//  ViewController.m
//  ProgressView
//
//  Created by sxiaojian on 15/10/29.
//  Copyright © 2015年 sxiaojian. All rights reserved.
//

#import "ViewController.h"
#import "GradientProgressView.h"
@implementation ViewController{
    

    __weak IBOutlet GradientProgressView *progressView;
    float progress;
}
- (void)viewDidLoad
{
    progress = 0;

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];


}
- (void)changeProgress{
    progress += 0.5;
    [progressView setProgress:progress animated:YES];

}
@end
