//
//  WXLoadImageView.h
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXLoadImageView : UIImageView

/// 指定URL下载图片失败时，重试的次数，默认为2次
@property (nonatomic, assign) NSUInteger retryTimes;
/// 是否裁剪为ImageView的尺寸，默认为NO
@property (nonatomic, assign) BOOL isScaleImage;

@end

NS_ASSUME_NONNULL_END
