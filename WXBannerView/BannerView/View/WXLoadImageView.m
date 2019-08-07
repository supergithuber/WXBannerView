//
//  WXLoadImageView.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXLoadImageView.h"
#import <objc/runtime.h>



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
