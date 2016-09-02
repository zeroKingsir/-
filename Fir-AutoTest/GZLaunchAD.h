//
//  GZLaunchAD.h
//  Fir-AutoTest
//
//  Created by G.Z on 16/9/1.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LaunchADBlock)(BOOL clickAD);

@interface GZLaunchAD : UIView
/**
 *  @param window keyWindow
 *  @param countTime 倒计时
 *  @param isShowCountTime 是否显示倒计时时间在跳过按钮上
 *  @param showSkipButton 是否显示跳过按钮
 *  @param isFullScreenAD 广告是否全屏
 *  @param localAdImgName 本地图片广告name
 *  @param iamgeUrl 网络图片广告URL
 *  @param canClickAD 广告图片是否点击
 *  @param aDBloack 回调Block
 *  @return self
 */
+ (instancetype)showWithWindw:(UIWindow *)window
                    countTime:(int)countTime
        showCountTimeOfButton:(BOOL)showCountTimeOfButton
               showSkipButton:(BOOL)showSkipButton
               isFullScreenAD:(BOOL)isFullScreenAD
               LocalAdImgName:(NSString *)localAdImgName
                     imageUrl:(NSString *)imageUrl
                   canClickAD:(BOOL)canClickAD
                      aDBlock:(LaunchADBlock)aDBlock;

@end
