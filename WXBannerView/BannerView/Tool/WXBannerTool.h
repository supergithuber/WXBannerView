//
//  WXBannerTool.h
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WXBannerImageType) {
    WXBannerImageTypeUnknown = 0, /// 未知
    WXBannerImageTypeJpeg    = 1, /// jpg
    WXBannerImageTypePng     = 2, /// png
    WXBannerImageTypeGif     = 3, /// gif
    WXBannerImageTypeTiff    = 4, /// tiff
    WXBannerImageTypeWebp    = 5, /// webp
};

NS_ASSUME_NONNULL_BEGIN
/// 图片类型判别，来源判别
/// 一些工具函数
@interface WXBannerTool : NSObject

/// gif存放数组 数组里面存放了判断网络图片或者GIF图片
@property(nonatomic,strong) NSMutableArray *imageTemps;

+ (instancetype)sharedInstance;

/**
 是不是一个有效的url

 @param url url
 */
+ (BOOL)isValidUrl:(NSString *)url;
/// 根据图片名 判断是否是gif图, 后缀
+ (BOOL)isGifImageWithImageName:(NSString*)imageName;
/// 根据图片url 判断是否是gif图
+ (BOOL)isGifImageWithURL:(id)url;


/// 判断是网络图片还是本地, 从协议判断
+ (BOOL)isLocalImageWithImageUrl:(NSString*)imageUrl;

/// 得到Gif
+ (UIImage *)getGifImageWithURL:(id)url;

/// md5加密
+ (NSString*)MD5StringWithString:(NSString*)string;

/**
 把图片剪裁到指定大小

 @param image 剪裁前图片
 @param size 目标size
 @param isScaleToMax 是取最大比例还是最小比例，YES表示取最大比例
 @return 剪裁后的图片
 */
+ (UIImage *)clipImage:(UIImage *)image
                  size:(CGSize)size
          isScaleToMax:(BOOL)isScaleToMax;
@end

NS_ASSUME_NONNULL_END
