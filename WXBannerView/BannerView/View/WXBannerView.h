//
//  WXBannerView.h
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 图片的几种类型
typedef NS_ENUM(NSInteger, WXBannerViewImageType) {
    WXBannerViewImageTypeMix = 0, /// 混合，本地图片、网络图片、网络GIF
    WXBannerViewImageTypeGIFAndNet,/// 网络GIF图片和网络图片混合
    WXBannerViewImageTypeLocality,/// 本地图片
    WXBannerViewImageTypeNetIamge,/// 网络图片
    WXBannerViewImageTypeGIFImage,/// 网络GIF图片
};

NS_ASSUME_NONNULL_BEGIN
@class WXBannerView;
@protocol KJBannerViewDelegate <NSObject>
@optional
/** 点击图片回调 */
- (void)bannerView:(WXBannerView *)banner selectIndex:(NSInteger)index;
@end


@interface WXBannerView : UIView

@end

NS_ASSUME_NONNULL_END
