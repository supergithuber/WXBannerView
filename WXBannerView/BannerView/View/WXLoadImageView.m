//
//  WXLoadImageView.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXLoadImageView.h"
#import <objc/runtime.h>

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
@end

/// MARK: - WXLoadImageView
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

@end
