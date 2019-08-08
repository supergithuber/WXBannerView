//
//  WXBannerImageCache.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/8.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXBannerImageCache.h"
#import "WXBannerTool.h"

#define WXBannerLoadImages [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WXBannerLoadImages"];

@interface WXBannerImageCache ()
/// imgKey : failedTimes
@property (nonatomic, strong)NSMutableDictionary *cacheFailedDic;

@end

@implementation WXBannerImageCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id _sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init{
    if (self==[super init]) {
        self.cacheFailedDic = [NSMutableDictionary dictionary];
    }
    return self;
}

// MARK: image
- (void)cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request{
    if (image == nil || request == nil) {
        return;
    }
    
    NSString *directoryPath = WXBannerLoadImages;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath,[WXBannerTool MD5StringWithString:[self keyForRequest:request]]];
    NSData *data = UIImagePNGRepresentation(image);
    if (data) {
        /// 缓存数据
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request{
    if (request) {
        NSString *directoryPath = WXBannerLoadImages;
        NSString *path = [NSString stringWithFormat:@"%@/%@", directoryPath, [self keyForRequest:request]];
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

- (void)clearAllCachedImage{
    NSString *directoryPath = WXBannerLoadImages;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    }
    [self clearCachedFailedDic];
}

// MARK: request
- (void)cacheFailRequest:(NSURLRequest *)request{
    NSNumber *faileTimes = [self.cacheFailedDic objectForKey:[self keyForRequest:request]];
    NSUInteger times = 0;
    if (faileTimes && [faileTimes respondsToSelector:@selector(integerValue)]) {
        times = [faileTimes integerValue];
    }
    times++;
    [self.cacheFailedDic setObject:@(times) forKey:[self keyForRequest:request]];
}
- (NSUInteger)failedTimesForRequest:(NSURLRequest *)request{
    NSNumber *faileTimes = [self.cacheFailedDic objectForKey:[self keyForRequest:request]];
    if (faileTimes && [faileTimes respondsToSelector:@selector(integerValue)]) {
        return faileTimes.integerValue;
    }
    return 0;
}


//MARK:- private
/// 拼接路径

- (void)clearCachedFailedDic{
    [self.cacheFailedDic removeAllObjects];
}

- (NSString *)keyForRequest:(NSURLRequest *)request {
    BOOL portait = NO;
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        portait = YES;
    }
    NSString *temkey = [NSString stringWithFormat:@"%@%@", request.URL.absoluteString, portait ? @"portait" : @"lanscape"];
    return [WXBannerTool MD5StringWithString:temkey];
}
@end
