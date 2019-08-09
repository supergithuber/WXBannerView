//
//  WXBannerImageCache.h
//  WXBannerView
//
//  Created by Wuxi on 2019/8/8.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXBannerImageCache : NSObject

+ (instancetype)sharedInstance;


// MARK: 缓存图片
/// 获取缓存图
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
/// 缓存图
- (void)cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request;
/// 清除缓存
- (void)clearAllCachedImage;
/// 获取缓存大小，bytes
- (unsigned long long)imageCachedSize;

// MARK: 缓存失败次数
/// 缓存失败次数
- (void)cacheFailRequest:(NSURLRequest *)request;
/// 获取失败次数
- (NSUInteger)failedTimesForRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
