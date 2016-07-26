//
//  CoverFlowLayout.m
//  CoverFlowLayout
//
//  Created by Grigory Avdyushin on 25.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "CoverFlowLayout.h"

@interface CoverFlowLayout ()
@property (strong, nonatomic) NSDictionary *layoutAttributes;
@end

@implementation CoverFlowLayout

- (CGSize)collectionViewContentSize
{
    const NSInteger count = [self.collectionView numberOfItemsInSection:0];
    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    
    return CGSizeMake(self.itemSize.width * count + width - self.itemSize.width, self.itemSize.height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    const NSInteger count = [self.collectionView numberOfItemsInSection:0];
    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    const CGFloat offset = (width - self.itemSize.width) / 2;
    
    NSMutableDictionary *layoutAttributes = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < count; ++i) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attr.frame = CGRectMake(offset + i * self.itemSize.width, self.sectionInset.top, self.itemSize.width, self.itemSize.height);
        
        layoutAttributes[indexPath] = attr;
    }
    
    self.layoutAttributes = layoutAttributes.copy;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size   = self.collectionView.bounds.size;
    
    [self.layoutAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(rect, visibleRect)) {
            const CGFloat d = CGRectGetMidX(visibleRect) - attributes.center.x;
            const CGFloat n = d / 100.0;
            const CGFloat s = 0.98 + 0.02*(1 - ABS(n));
            
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            attributes.transform = scale;
            
            [layoutAttributes addObject:attributes];
        }
    }];
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutAttributes[indexPath];
}

@end
