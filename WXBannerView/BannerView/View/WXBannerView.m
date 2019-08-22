//
//  WXBannerView.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/7.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXBannerView.h"
#import "WXBannerViewFlowLayout.h"
#import "WXPageControl.h"

@interface WXBannerView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) WXBannerViewFlowLayout *flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation WXBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self commonConfig];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)commonConfig{
    _infiniteLoop = YES;
    _autoScroll = YES;
    _isZoom = NO;
    _itemWidth = self.bounds.size.width;
    _itemSpace = 0;
    
}

//MARK:- collectionView dataSource

//MARK:- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//MARK:- scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

//MARK:- lazy
- (WXPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[WXPageControl alloc] initWithFrame:CGRectMake(0,
                                                                       self.bounds.size.height - 15,
                                                                       self.bounds.size.width,
                                                                       15)];
        // 默认设置
        _pageControl.style = WXPageControlStyleRectangle;
        _pageControl.normalColor = UIColor.lightGrayColor;
        _pageControl.selectedColor = UIColor.whiteColor;
        _pageControl.currentIndex = 0;//[self currentIndex];
    }
    return _pageControl;
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = self.backgroundColor;
    }
    return _collectionView;
}
- (WXBannerViewFlowLayout *)flowLayout{
    if(!_flowLayout){
        _flowLayout = [[WXBannerViewFlowLayout alloc]init];
        _flowLayout.isZoom = self.isZoom;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}
@end
