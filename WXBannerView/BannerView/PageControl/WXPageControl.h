//
//  WXPageControl.h
//  WXBannerView
//
//  Created by Wuxi on 2019/8/5.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 pageControl样式

 - WXPageControlStyleRectangle: 长方形（默认）
 - WXPageControlStyleCircle: 圆形
 - WXPageControlStyleSquare: 正方形
 */
typedef NS_ENUM(NSInteger, WXPageControlStyle){
    WXPageControlStyleRectangle = 0,
    WXPageControlStyleCircle,
    WXPageControlStyleSquare,
};

@interface WXPageControl : UIPageControl

/// 总页数
@property (nonatomic, assign)NSInteger totalPages;
/// 当前页数
@property (nonatomic, assign)NSInteger currentIndex;
/// 选中颜色, 默认whiteColor
@property (nonatomic, strong)UIColor *selectedColor;
/// 非选中颜色, 默认lightGrayColor
@property (nonatomic, strong)UIColor *normalColor;
/// 样式, 默认WXPageControlStyleRectangle
@property (nonatomic, assign)WXPageControlStyle style;
/// item的宽度,default:8
@property (nonatomic, assign)CGFloat itemWidth;
/// item之间的间隔,default:4
@property (nonatomic, assign)CGFloat itemMargin;

//- (instancetype)initWithControlStyle:(WXPageControlStyle)style
//                          totalPages:(NSInteger)totalPages
//                           itemWidth:(CGFloat)itemWidth
//                          itemMargin:(CGFloat)itemMargin;

@end

NS_ASSUME_NONNULL_END
