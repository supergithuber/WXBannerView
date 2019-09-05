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
/// 滚动方向
typedef NS_ENUM(NSInteger, WXBannerViewRollDirection) {
    WXBannerViewRollDirectionRightToLeft = 0, /// 默认，从右往左
    WXBannerViewRollDirectionLeftToRight,    /// 从左往右
};

NS_ASSUME_NONNULL_BEGIN
@class WXBannerView;
@class WXPageControl;

@protocol WXBannerViewDelegate <NSObject>
@optional
/** 点击图片回调 */
- (void)bannerView:(WXBannerView *)banner selectIndex:(NSInteger)index;
@end


@interface WXBannerView : UIView

/// 支持自定义Cell，自定义Cell需继承自 KJBannerViewCell
@property (nonatomic,strong) Class itemClass;

/** 网络数组 1.本地  2.图片 url string  */
@property (nonatomic,strong) NSArray *imageDatas;
/** 是否无线循环, 默认yes */
@property (nonatomic,assign) BOOL infiniteLoop;
/** 是否自动滑动, 默认yes */
@property (nonatomic,assign) BOOL autoScroll;
/// 是否缩放, 默认不缩放
@property (nonatomic,assign) BOOL isZoom;
/// 滚动方向，默认从右到左
@property (nonatomic,assign) WXBannerViewRollDirection rollDirection;
/// 自动滚动间隔时间, 默认2s
@property (nonatomic,assign) CGFloat autoScrollTimeInterval;

//MARK:- view property
/** 分页控制器 */
@property (nonatomic,strong) WXPageControl *pageControl;
/** 占位图, 用于网络未加载到图片时 */
@property (nonatomic,strong) UIImage *placeholderImage;
/** 轮播图片的ContentMode, 默认为 UIViewContentModeScaleToFill */
@property (nonatomic,assign) UIViewContentMode bannerImageViewContentMode;
/// cell宽度  左右宽度
@property (nonatomic,assign) CGFloat itemWidth;
/// cell间距  上下高度, 默认为0
@property (nonatomic,assign) CGFloat itemSpace;

/// 自带Cell可设置属性
/** imagView圆角, 默认为0 */
@property (nonatomic,assign) CGFloat imgCornerRadius;
/** cell的占位图, 用于网络未加载到图片时 */
@property (nonatomic,strong) UIImage *cellPlaceholderImage;
/** 图片的样式, 默认 KJBannerViewImageTypeLocality 网络图片 */
@property (nonatomic,assign) WXBannerViewImageType imageType;

//MARK:- delegate
/// 代理
@property (nonatomic,weak) id<WXBannerViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
