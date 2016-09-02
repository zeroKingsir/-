//
//  GZLaunchAD.m
//  Fir-AutoTest
//
//  Created by G.Z on 16/9/1.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "GZLaunchAD.h"
#import "UIImageView+WebCache.h"

#define GZLaunchADBottomHeight 130

@interface  GZLaunchAD ()
@property (nonatomic,weak)UIImageView *adImageView;
@property (nonatomic,assign)int adTime;
//倒计时总时长,默认6秒
@property (nonatomic,weak)UIButton *skipBtn;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,copy)LaunchADBlock block;
@property (nonatomic,assign)BOOL showCountTimeOfButton;

@end
@implementation GZLaunchAD

+ (instancetype)showWithWindw:(UIWindow *)window
                    countTime:(int)countTime
        showCountTimeOfButton:(BOOL)showCountTimeOfButton
               showSkipButton:(BOOL)showSkipButton
               isFullScreenAD:(BOOL)isFullScreenAD
               LocalAdImgName:(NSString *)localAdImgName
                     imageUrl:(NSString *)imageUrl
                   canClickAD:(BOOL)canClickAD
                      aDBlock:(LaunchADBlock)aDBlock
{
    GZLaunchAD *ad = [[GZLaunchAD alloc] init];
    ad.frame = window.bounds;
    ad.adTime = countTime;
    ad.block  = aDBlock;
    ad.showCountTimeOfButton = showCountTimeOfButton;
    [window makeKeyAndVisible];
    
    //获取启动图片
    CGSize viewSize = window.bounds.size;
    //横屏设置成"Landscape"
    NSString *viewOrientation = @"Portrait";
    NSString *launchImgName = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize,viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImgName = dict[@"UILaunchImageName"];
        }
    }
    UIImage *launchImage = [UIImage imageNamed:launchImgName];
    ad.backgroundColor= [UIColor colorWithPatternImage:launchImage];
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.contentMode = UIViewContentModeScaleAspectFill;
    ad.adImageView = adImageView;
    if (localAdImgName) {
        
        adImageView.image = [UIImage imageNamed:localAdImgName];
    }else{
        [adImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    CGFloat imageViewHeight;
    if (isFullScreenAD) {
        imageViewHeight = viewSize.height;
    }else{
        imageViewHeight = viewSize.height - GZLaunchADBottomHeight;
    }
    adImageView.frame = CGRectMake(0, 0, viewSize.width, imageViewHeight);
    if (canClickAD) {
        
        adImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:ad action:@selector(tapClick)];
        [adImageView addGestureRecognizer:tap];
    }
    [ad addSubview:adImageView];
    if (showSkipButton) {
        
        UIButton *skipButton = [[UIButton alloc] init];
        [skipButton addTarget:ad action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
        skipButton.titleLabel.font = [UIFont systemFontOfSize:12];
        skipButton.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.377];
        CGFloat width;
        CGFloat height = 25;
        if (showCountTimeOfButton) {
            
            width = 80;
        }else{
            width = 65;
            [skipButton setTitle:@"跳过广告" forState:UIControlStateNormal];
        }
        skipButton.frame = CGRectMake(viewSize.width - 20 - width, 40, width,height);
        skipButton.layer.cornerRadius = height/2;
        skipButton.clipsToBounds = YES;
        ad.skipBtn = skipButton;
        [ad addSubview:skipButton];
    }
    [window addSubview:ad];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:ad selector:@selector(autoCount) userInfo:nil repeats:YES];
    ad.timer = timer;
    [timer fire];
    return ad;
}
- (void)autoCount{

    if (self.adTime == 0) {
    
        [self hide];
        return;
    }
    if (self.skipBtn && self.showCountTimeOfButton) {
        
        if (self.adTime == 1) {
            
            [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过广告 %d",self.adTime] forState:UIControlStateNormal];
        }else{
            [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过广告 %d",self.adTime] forState:UIControlStateNormal];
        }
    }
    self.adTime--;
    
}

- (void)hide{
    
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if(self.block ){
        
            self.block(NO);
        }
        [self removeFromSuperview];
    }];

}
- (void)skip{

    [self hide];
}
- (void)tapClick{

    if (self.block) {
        
        [self hide];
        self.block(YES);
    }
}
@end
