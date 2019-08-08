//
//  WXBannerTool.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXBannerTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WXBannerTool

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
        self.imageTemps = [NSMutableArray array];
    }
    return self;
}

// MARK: - public
/// 是不是一个有效的url
+ (BOOL)isValidUrl:(NSString *)url{
    NSString *regex = @"^[a-zA-Z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [urlTest evaluateWithObject:url];
}

/// 根据图片名 判断是否是gif图
+ (BOOL)isGifImageWithImageName:(NSString*)imageName{
    NSString *ext = imageName.pathExtension.lowercaseString;
    return [ext isEqualToString:@"gif"] ? YES : NO;
}

/// 根据图片url 判断是否是gif图, 下载图片
+ (BOOL)isGifImageWithURL:(id)url{
    if (![url isKindOfClass:[NSURL class]]) {
        url = [NSURL URLWithString:url];
    }
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [self contentTypeWithImageData:data] == WXBannerImageTypeGif ? YES : NO;
}

/// 判断是网络图片还是本地, 从协议判断
+ (BOOL)isLocalImageWithImageUrl:(NSString *)imageUrl{
    return !([imageUrl hasPrefix:@"http"] || [imageUrl hasPrefix:@"https"]);
}

/// 得到Gif
+ (UIImage *)getGifImageWithURL:(id)url{
    // 1.加载Gif图片，转换成Data类型
    if (![url isKindOfClass:[NSURL class]]) {
        url = [NSURL URLWithString:url];
    }
    NSData *data = [NSData dataWithContentsOfURL:url];
    // 2.将data数据转换成CGImageSource对象
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(CFBridgingRetain(data), nil);
    size_t imageCount = CGImageSourceGetCount(imageSource);
    
    // 3.取出图片
    UIImage *animatedImage;
    if (imageCount <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }else{
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval totalDuration = 0;
        for (int i = 0; i<imageCount; i++) {
            //取出每一张图片
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
            [images addObject:[UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(cgImage);
            //持续时间
            NSDictionary *properties = (__bridge_transfer NSDictionary*)CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
            NSDictionary *gifDict = [properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *frameDuration = [gifDict objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime];
            totalDuration += frameDuration.doubleValue;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:totalDuration];
    }
    CFRelease(imageSource);
    return animatedImage;
}

+ (NSString*)MD5StringWithString:(NSString*)string{
    const char *original_str = [string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [outPutStr appendFormat:@"%02X", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [[outPutStr lowercaseString] copy];
}

+ (UIImage *)clipImage:(UIImage *)image
                  size:(CGSize)size
          isScaleToMax:(BOOL)isScaleToMax{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGSize aspectFitSize = CGSizeZero;
    if (image.size.width != 0 && image.size.height != 0) {
        CGFloat rateWidth = size.width / image.size.width;
        CGFloat rateHeight = size.height / image.size.height;
        
        CGFloat rate = isScaleToMax ? MAX(rateHeight, rateWidth) : MIN(rateHeight, rateWidth);
        aspectFitSize = CGSizeMake(image.size.width * rate, image.size.height * rate);
    }
    
    [image drawInRect:CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}
// MARK: - private
/// 根据image的data 判断图片类型
+ (WXBannerImageType)contentTypeWithImageData:(NSData*)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return WXBannerImageTypeJpeg;
        case 0x89:
            return WXBannerImageTypePng;
        case 0x47:
            return WXBannerImageTypeGif;
        case 0x49:
        case 0x4D:
            return WXBannerImageTypeTiff;
        case 0x52:
            if ([data length] < 12) {
                return WXBannerImageTypeUnknown;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return WXBannerImageTypeWebp;
            }
            return WXBannerImageTypeUnknown;
    }
    return WXBannerImageTypeUnknown;
}
@end
