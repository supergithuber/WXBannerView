//
//  WXBannerViewFlowLayout.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/6.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "WXBannerViewFlowLayout.h"

@implementation WXBannerViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    // 1.获取cell对应的attributes对象
    NSArray* arrayAttr = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    if(!self.isZoom) return arrayAttr;
    
    // 2.计算整体的中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    // 3.修改一下attributes对象
    for (UICollectionViewLayoutAttributes *attr in arrayAttr) {
        // 3.1 计算每个cell的中心点距离
        CGFloat distance = ABS(attr.center.x - centerX);
        // 3.2 距离越大，缩放比越小，距离越小，缩放比越大
        CGFloat factor = 0.001;
        CGFloat scale = 1.0 / (1 + distance * factor);
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return arrayAttr;
}


/**
 当collectionView的显示范围发生改变的时候是否需要重新刷新布局
 return YES, 表示需要重新刷新布局 就会重新调用下面的方法
 1.layoutAttributesForElementsInRect 这个方法
 2.prepareLayout

 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
