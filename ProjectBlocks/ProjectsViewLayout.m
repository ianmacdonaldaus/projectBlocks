//
//  ProjectsViewLayout.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 11/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectsViewLayout.h"

@implementation ProjectsViewLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

- (void)awakeFromNib
{
    self.itemSize = CGSizeMake(250 , 250);
    self.minimumInteritemSpacing = 40.0;
    self.minimumLineSpacing = 40.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    float viewWidth= self.collectionView.frame.size.width;
    float viewHeight= self.collectionView.frame.size.height;
    self.sectionInset = UIEdgeInsetsMake((viewHeight - 300) /2, (viewWidth / 2) , (self.collectionView.bounds.size.height - 300) /2, (self.collectionView.bounds.size.width - 300));
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue; // skip headers
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (void)setLineAttributes:(UICollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect
{
    CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
    if (ABS(distance) < ACTIVE_DISTANCE) {
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        attributes.zIndex = 1;
    }
    else
    {
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
    }
}



@end
