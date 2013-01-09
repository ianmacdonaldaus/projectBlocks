//
//  CVLayout.h
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CVViewController.h"

@class TasksViewLayout;

@interface TasksViewLayout : UICollectionViewLayout <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) UIEdgeInsets triggerScrollingEdgeInsets;
@property (assign, nonatomic) CGFloat scrollingSpeed;
@property (strong, nonatomic) NSTimer *scrollingTimer;

@property (weak, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (weak, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (assign, nonatomic) BOOL alwaysScroll;

- (void)setUpGestureRecognizersOnCollectionView;


@end


@protocol TasksViewDelegateLayout <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout itemAtIndexPath:(NSIndexPath *)theFromIndexPath willMoveToIndexPath:(NSIndexPath *)theToIndexPath;

@optional

- (CGFloat)widthForItemAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL)sequentialForItemAtIndexPath:(NSIndexPath*)indexPath;

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout willBeginReorderingAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout didBeginReorderingAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout willEndReorderingAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout didEndReorderingAtIndexPath:(NSIndexPath *)theIndexPath;

@end


