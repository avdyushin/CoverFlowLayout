//
//  ViewController.m
//  CoverFlowLayout
//
//  Created by Grigory Avdyushin on 25.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "ViewController.h"
#import "SampleCell.h"
#import "CoverFlowLayout.h"

@interface ViewController () <UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) CoverFlowLayout *layout;
@property (assign, nonatomic) NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.layout = [CoverFlowLayout new];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    self.layout.itemSize = CGSizeMake(width * 0.7f, 100.f);
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.index = 2;
    self.collectionView.contentOffset = CGPointMake(self.layout.itemSize.width * 2, 0);
    self.items = @[@4, @5, @1, @2, @3, @4, @5, @1, @2];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SampleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.items[indexPath.row]];
    if (indexPath.row < 2 || indexPath.row >= self.items.count - 2) {
        cell.isCopy = YES;
    } else {
        cell.isCopy = NO;
    }
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    const CGFloat cellWidth = layout.itemSize.width;
    NSInteger index = lrint(targetContentOffset->x/cellWidth);
    if (index > self.index) {
        index = self.index + 1;
    } else if (index < self.index) {
        index = self.index - 1;
    }
    if (index < 1) {
        targetContentOffset->x = 0;
    } else {
        targetContentOffset->x = index * cellWidth;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    const CGFloat cellWidth = layout.itemSize.width;
    self.index = lrint(scrollView.contentOffset.x / cellWidth);
    [self adjustContentOffset:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustContentOffset:scrollView];
}

- (void)adjustContentOffset:(UIScrollView *)scrollView
{
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    const CGFloat cellWidth = layout.itemSize.width;
    const NSInteger total = [collectionView numberOfItemsInSection:0];
    if (scrollView.contentOffset.x < cellWidth ) {
        scrollView.contentOffset = CGPointMake(cellWidth * (total - 4), scrollView.contentOffset.y);
    } else if (scrollView.contentOffset.x < cellWidth * 2) {
        scrollView.contentOffset = CGPointMake(cellWidth * (total - 3), scrollView.contentOffset.y);
    } else if (scrollView.contentOffset.x >= cellWidth * (total - 1)) {
        scrollView.contentOffset = CGPointMake(cellWidth * 3, scrollView.contentOffset.y);
    } else if (scrollView.contentOffset.x >= cellWidth * (total - 2)) {
        scrollView.contentOffset = CGPointMake(cellWidth * 2, scrollView.contentOffset.y);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.collectionView.contentOffset = CGPointMake(self.index * self.layout.itemSize.width, self.collectionView.contentOffset.y);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

@end
