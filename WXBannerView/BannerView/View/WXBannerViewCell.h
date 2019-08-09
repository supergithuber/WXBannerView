//
//  WXBannerViewCell.h
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXBannerViewCell : UICollectionViewCell

/// 数据模型 - 用于自定义样式传递数据
@property (nonatomic,strong) NSObject *model;

/// 图片显示方式
@property (nonatomic,assign) UIViewContentMode contentMode;
/// 圆角
@property (nonatomic,assign) CGFloat imgCornerRadius;
/// url
@property (nonatomic,strong) NSString *imageUrl;
/// 占位图
@property (nonatomic,strong) UIImage *placeholderImage;
/// 图片的样式, 默认 WXBannerViewImageTypeLocality 网络图片
@property (nonatomic,assign) WXBannerViewImageType imageType;

- (instancetype)initWithImageType:(WXBannerViewImageType)imageType;

@end

NS_ASSUME_NONNULL_END
