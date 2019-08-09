//
//  WXBannerViewCell.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXBannerViewCell.h"
#import "WXLoadImageView.h"
#import "WXBannerTool.h"

@interface WXBannerViewCell()

@property (nonatomic, strong) WXLoadImageView *loadImageView;

@end

@implementation WXBannerViewCell

- (instancetype)initWithImageType:(WXBannerViewImageType)imageType{
    if (self = [self initWithImageType:imageType
                                 frame:CGRectZero]){
        
    }
    return self;
}

- (instancetype)initWithImageType:(WXBannerViewImageType)imageType
                            frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        _imageType = imageType;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [self initWithImageType:WXBannerViewImageTypeLocality
                                 frame:frame]){
        
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
    switch (_imageType) {
            /// 混合，本地图片、网络图片、网络GIF
        case WXBannerViewImageTypeMix:{
            BOOL isLocal = [WXBannerTool isLocalImageWithImageUrl:imageUrl];
            if (isLocal) { /// 本地图片
                self.loadImageView.image = [UIImage imageNamed:imageUrl];
            }else{
                [self _setImageWithURL:imageUrl];
            }
            break;
        }
        case WXBannerViewImageTypeGIFAndNet:{/// 网络GIF图片和网络图片混合
            [self _setImageWithURL:imageUrl];
            break;
        }
        case WXBannerViewImageTypeLocality:{/// 本地图片
            self.loadImageView.image = [UIImage imageNamed:imageUrl];
            break;
        }
        case WXBannerViewImageTypeNetIamge:{/// 网络图片
            [self.loadImageView setImageWithURLString:imageUrl placeholder:self.placeholderImage];
            break;
        }
        case WXBannerViewImageTypeGIFImage:{/// 网络GIF图片
            [self _setImageWithURL:imageUrl];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private
- (void)_setImageWithURL:(NSString*)imageUrl{
    __block NSString *name = [WXBannerTool MD5StringWithString:imageUrl];
    __block BOOL next = NO;
    [[WXBannerTool sharedInstance].imageTemps enumerateObjectsUsingBlock:^(id _Nonnull obj,
                                                                           NSUInteger idx,
                                                                           BOOL * _Nonnull stop) {
        //判断是否已经存在
        if ([obj[@"name"] isEqualToString:name]) {
            //判断是否为GIF
            if ([obj[@"gif"] integerValue]) {
                self.loadImageView.image = obj[@"image"];
            }else{
                [self.loadImageView setImageWithURLString:imageUrl
                                              placeholder:self.placeholderImage];
            }
            next = YES;
            *stop = YES;
        }
    }];
    if (next) return;
    NSDictionary *dict;
    BOOL ifGif = [WXBannerTool isGifImageWithURL:imageUrl];
    if (ifGif) {
        //5.获取gif图
        UIImage *animatedImage = [WXBannerTool getGifImageWithURL:imageUrl];
        self.loadImageView.image = animatedImage;
        dict = @{@"name":name,
                 @"image":animatedImage,
                 @"gif":@(ifGif)};
    }else{
        //5.显示网络图片
        [self.loadImageView setImageWithURLString:imageUrl
                                      placeholder:self.placeholderImage];
        dict = @{@"name":name,
                 @"gif":@(ifGif)};
    }
    [[WXBannerTool sharedInstance].imageTemps addObject:dict];
}
/// MARK: lazy
- (WXLoadImageView *)loadImageView{
    if(!_loadImageView){
        _loadImageView = [[WXLoadImageView alloc]initWithFrame:self.bounds];
        _loadImageView.image = self.placeholderImage;
        _loadImageView.contentMode = self.contentMode;
        [self.contentView addSubview:_loadImageView];
        if (self.imgCornerRadius > 0) {
            /// 画圆
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_loadImageView.bounds
                                                                cornerRadius:_imgCornerRadius];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
            /// 设置大小
            maskLayer.frame = self.bounds;
            /// 设置图形样子
            maskLayer.path = maskPath.CGPath;
            _loadImageView.layer.mask = maskLayer;
        }
    }
    return _loadImageView;
}
@end
