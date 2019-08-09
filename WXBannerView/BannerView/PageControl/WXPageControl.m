//
//  WXPageControl.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/5.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXPageControl.h"

@interface WXPageControl ()

@end

@implementation WXPageControl

- (instancetype)initWithControlStyle:(WXPageControlStyle)style
                          totalPages:(NSInteger)totalPages
                           itemWidth:(CGFloat)itemWidth
                          itemMargin:(CGFloat)itemMargin{
    if (self = [self initWithFrame:CGRectZero
                      controlStyle:style
                        totalPages:totalPages
                         itemWidth:itemWidth
                        itemMargin:itemMargin]){
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                 controlStyle:(WXPageControlStyle)style
                   totalPages:(NSInteger)totalPages
                    itemWidth:(CGFloat)itemWidth
                   itemMargin:(CGFloat)itemMargin{
    if (self = [super initWithFrame:frame]){
        _normalColor = [UIColor lightGrayColor];
        _selectedColor = [UIColor whiteColor];
        _currentIndex = 0;
        _style = style;
        _totalPages = totalPages;
        _itemWidth = itemWidth;
        _itemMargin = itemMargin;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithFrame:CGRectZero
                      controlStyle:WXPageControlStyleRectangle
                        totalPages:0
                         itemWidth:0
                        itemMargin:0]){
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupUI];
}

- (void)setupUI{
    CGFloat centerX = self.center.x;
    CGFloat totalWidth = (_itemWidth * _totalPages) + ((_totalPages - 1) * _itemMargin);
    CGFloat originItemX = centerX - (totalWidth / 2);
    
    for (int i = 0; i < _totalPages; i++) {
        UIView *aview = [UIView new];
        aview.backgroundColor = i == _currentIndex ? _selectedColor : _normalColor;
        switch (_style) {
            case WXPageControlStyleCircle:
                aview.frame = CGRectMake(originItemX + (_itemWidth + _itemMargin) * i, 0, _itemWidth, _itemWidth);
                aview.layer.cornerRadius = _itemWidth / 2 ;
                aview.layer.masksToBounds = YES;
                break;
            case WXPageControlStyleSquare:
                aview.frame = CGRectMake(originItemX + (_itemWidth + _itemMargin) * i, 0, _itemWidth, _itemWidth);
                break;
            case WXPageControlStyleRectangle:
                aview.frame = CGRectMake(originItemX + (_itemWidth + _itemMargin) * i, 0, _itemWidth, _itemWidth/4.0);
                break;
            default:
                break;
        }
        [self addSubview:aview];
    }
}


- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        /// 遍历修改颜色
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.backgroundColor = idx == currentIndex ? self.selectedColor : self.normalColor;
        }];
    }
}

@end
