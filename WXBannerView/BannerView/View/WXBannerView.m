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
#import "WXBannerViewCell.h"
#import "WXBannerTool.h"

NSString * const kBannerViewCellReuseIdentifier = @"com.sivan.wxbannerviewcell";

@interface WXBannerView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) WXBannerViewFlowLayout *flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSUInteger imgTemps; // 总数
/// 是否自定义Cell, 默认no
@property (nonatomic,assign) BOOL isCustomCell;
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
    _imgCornerRadius = 0;
    _autoScrollTimeInterval = 2;
    _bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _isCustomCell = NO;
    _rollDirection = WXBannerViewRollDirectionRightToLeft;
    _imageType = WXBannerViewImageTypeNetIamge;
    _cellPlaceholderImage = [UIImage imageNamed:@"WXBannerView.bundle/WXBannerPlaceholderImage"];
    self.itemClass = [WXBannerViewCell class];
    
}


#pragma mark  - setter or getter
- (void)setItemClass:(Class)itemClass{
    _itemClass = itemClass;
    if (![NSStringFromClass(itemClass) isEqualToString:@"WXBannerViewCell"]) {
        _isCustomCell = YES;
    }
    /// 注册cell
    [self.collectionView registerClass:_itemClass forCellWithReuseIdentifier:kBannerViewCellReuseIdentifier];
}
- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
}
- (void)setItemSpace:(CGFloat)itemSpace{
    _itemSpace = itemSpace;
    self.flowLayout.minimumLineSpacing = itemSpace;
}
- (void)setIsZoom:(BOOL)isZoom{
    _isZoom = isZoom;
    self.flowLayout.isZoom = isZoom;
}
- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    //创建之前，停止定时器
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupTimer];
    }
}
- (void)setImageDatas:(NSArray *)imageDatas{
    _imageDatas = imageDatas;
    [[WXBannerTool sharedInstance].imageTemps removeAllObjects];
    self.pageControl.totalPages = _imageDatas.count;
}

/// timer
/// 释放计时器
- (void)invalidateTimer{
    [_timer invalidate];
    _timer = nil;
}
/// 开启计时器
- (void)setupTimer{
    [self invalidateTimer]; // 创建定时器前先停止定时器,不然会出现僵尸定时器,导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}
/// 自动滚动
- (void)automaticScroll{
    if(_imgTemps == 0) return;
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex;
    /// 滚动方向设定
    if (_rollDirection == WXBannerViewRollDirectionRightToLeft) {
        targetIndex = currentIndex + 1;
    }else{
        if (currentIndex == 0) {
            currentIndex = _imgTemps;
        }
        targetIndex = currentIndex - 1;
    }
    [self scrollToIndex:targetIndex];
}
/// 滚动到指定位置
- (void)scrollToIndex:(NSInteger)index{
    if(index >= _imgTemps){ //滑到最后则调到中间
        if(self.infiniteLoop){
            index = _imgTemps * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
/// 当前位置
- (NSInteger)currentIndex{
    if(self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) return 0;
    NSInteger index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平滑动
        index = (self.collectionView.contentOffset.x + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    }else{
        index = (self.collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0,index);
}
//MARK:- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgTemps;
}

//MARK:- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger idx = [self currentIndex] % self.imageDatas.count;
    if ([self.delegate respondsToSelector:@selector(bannerView:selectIndex:)]) {
        [self.delegate bannerView:self selectIndex:idx];
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerViewCellReuseIdentifier forIndexPath:indexPath];
    long itemIndex = (int)indexPath.item % self.imageDatas.count;
    if (_isCustomCell) {
        cell.model = self.imageDatas[itemIndex];
    }else{
        cell.imgCornerRadius = self.imgCornerRadius;
        cell.placeholderImage = self.cellPlaceholderImage;
        cell.contentMode = self.bannerImageViewContentMode;
        cell.imageType = self.imageType;
        cell.imageUrl = self.imageDatas[itemIndex];
    }
    return cell;
}
//MARK:- scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self dragStart];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self dragEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self dragEnd];
}

- (void)dragStart{
    self.autoScroll = false;
}
- (void)dragEnd{
    self.autoScroll = true;
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
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds
                                            collectionViewLayout:self.flowLayout];
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
