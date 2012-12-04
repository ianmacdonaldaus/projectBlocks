//
//  CVLayout.h
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CVViewController.h"

@class CVLayout;

@protocol CollectionViewDelegateCVLayout <UICollectionViewDelegate>
@optional

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout widthForItemAtIndexPath:(NSIndexPath*)indexPath;


@end


@interface CVLayout : UICollectionViewLayout

@end
