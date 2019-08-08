//
//  WXLoadImageView.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXLoadImageView.h"
#import <objc/runtime.h>
#import "WXBannerImageCache.h"
#import "WXBannerTool.h"

/// 网络请求回调
typedef void (^WXDownLoadDataBlock)(NSData * _Nullable data, NSError * _Nullable error);

/// MARK: - WXImageDownloader
@interface WXImageDownloader : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;
@property (nonatomic, copy) WXDownloadProgressBlock progressBlock;
@property (nonatomic, copy) WXDownLoadDataBlock callbackOnFinished;

/// 下载图片
- (void)startDownloadImageWithUrl:(NSString *)url
                         progress:(WXDownloadProgressBlock)progress
                         complete:(WXDownLoadDataBlock)complete;

@end

@implementation WXImageDownloader

- (void)startDownloadImageWithUrl:(NSString *)url
                         progress:(WXDownloadProgressBlock)progress
                         complete:(WXDownLoadDataBlock)complete{
    self.progressBlock = progress;
    self.callbackOnFinished = complete;
    
    if ([NSURL URLWithString:url] == nil) {
        NSError *error = [NSError errorWithDomain:@"com.sivanwu.bannerView" code:400 userInfo:@{@"errorMessage": @"URL不正确"}];
        complete(nil, error);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    [task resume];
    self.task = task;
}
/// 下载过程
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.currentLength = totalBytesWritten;
    self.totalLength = totalBytesExpectedToWrite;
    
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
}

/// 下载完成
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
    
    if (self.callbackOnFinished) {
        self.callbackOnFinished(data, nil);
        // 防止重复调用
        self.callbackOnFinished = nil;
    }
}

/// 下载失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        if (self.callbackOnFinished) {
            self.callbackOnFinished(nil, error);
        }
        self.callbackOnFinished = nil;
    }
    
}
@end

/// MARK: - WXLoadImageView
@interface WXLoadImageView (){
    __weak WXImageDownloader *_imageDownloader;
}

@end

@implementation WXLoadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureLayout];
    }
    return self;
}

- (void)configureLayout {
    self.contentMode = UIViewContentModeScaleToFill;
    self.retryTimes = 2;
    self.isScaleImage = NO;
}

- (void)setImageWithURLString:(NSString *)url
                  placeholder:(UIImage *)placeholderImage{
    
    [self setImageWithURLString:url
                    placeholder:placeholderImage
                     completion:nil];
}
/// 下载图
- (void)setImageWithURLString:(NSString *)url
                  placeholder:(UIImage *)placeholderImage
                   completion:(WXDownLoadImageBlock)completion{
    self.completionBlock = completion;
    if (url == nil || [url isKindOfClass:[NSNull class]] || (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])){
        self.image = placeholderImage;
        if (completion) {
            self.completionBlock(self.image);
        }
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self downloadWithReqeust:request placeHolder:placeholderImage];
}

//MARK: - private
- (void)downloadWithReqeust:(NSURLRequest *)theRequest
                placeHolder:(UIImage *)placeHolder {
    UIImage *cachedImage = [[WXBannerImageCache sharedInstance] cachedImageForRequest:theRequest];
    if (cachedImage) {
        self.image = cachedImage;
        if (self.completionBlock) {
            self.completionBlock(cachedImage);
        }
        return;
    }
    self.image = placeHolder;
    
    /// 判断失败次数
    if ([[WXBannerImageCache sharedInstance] failedTimesForRequest:theRequest] >= self.retryTimes){
        return;
    }
    
    [self cancelRequest];
    _imageDownloader = nil;
    
    __weak __typeof(self) weakSelf = self;
    WXImageDownloader *downloader = [[WXImageDownloader alloc] init];
    _imageDownloader = downloader;
    [downloader startDownloadImageWithUrl:theRequest.URL.absoluteString
                                 progress:^(unsigned long long total, unsigned long long current) {
                                     if (self.progressBlock){
                                         self.progressBlock(total, current);
                                     }
                                 }
                                 complete:^(NSData * _Nullable data, NSError * _Nullable error) {
                                     if (data != nil && error == nil) {
                                         //成功
                                         dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                             UIImage *image = [UIImage imageWithData:data];
                                             UIImage *finalImage = image;
                                             if (image) {
                                                 if (weakSelf.isScaleImage) {
                                                     // 剪裁
                                                     if (fabs(weakSelf.frame.size.width - image.size.width) != 0 && fabs(weakSelf.frame.size.height - image.size.height) != 0) {
                                                         finalImage = [WXBannerTool clipImage:image
                                                                                         size:weakSelf.frame.size
                                                                                 isScaleToMax:YES];
                                                     }
                                                 }
                                                 [[WXBannerImageCache sharedInstance] cacheImage:finalImage
                                                                                      forRequest:theRequest];
                                             }else{
                                                 [[WXBannerImageCache sharedInstance] cacheFailRequest:theRequest];
                                             }
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (finalImage) {
                                                     weakSelf.image = finalImage;
                                                     !weakSelf.completionBlock?:weakSelf.completionBlock(weakSelf.image);
                                                 } else {// error data
                                                     !weakSelf.completionBlock?:weakSelf.completionBlock(placeHolder);
                                                 }
                                             });
                                         });

                                     }else{
                                         [[WXBannerImageCache sharedInstance] cacheFailRequest:theRequest];
                                         if (self.completionBlock){
                                             self.completionBlock(placeHolder);
                                         }
                                     }
                                 }];
}

- (void)cancelRequest {
    
    [_imageDownloader.task cancel];
}
@end
