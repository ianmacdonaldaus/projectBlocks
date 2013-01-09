//
//  TasksViewLayout.m
//
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//  Based on:
//
//  LXReorderableCollectionViewFlowLayout.m
//
//  Created by Stan Chang Khin Boon on 1/10/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.

#import "TasksViewLayout.h"
#import <QuartzCore/QuartzCore.h>

#define ITEM_SIZE 40

#define LX_FRAMES_PER_SECOND 60.0

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
LXS_CGPointAdd(CGPoint thePoint1, CGPoint thePoint2) {
    return CGPointMake(thePoint1.x + thePoint2.x, thePoint1.y + thePoint2.y);
}
#endif

typedef NS_ENUM(NSInteger, LXReorderableCollectionViewFlowLayoutScrollingDirection) {
    LXReorderableCollectionViewFlowLayoutScrollingDirectionUp = 1,
    LXReorderableCollectionViewFlowLayoutScrollingDirectionDown,
    LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft,
    LXReorderableCollectionViewFlowLayoutScrollingDirectionRight
};

static NSString * const kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey = @"LXScrollingDirection";

@interface TasksViewLayout();

@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end

@implementation TasksViewLayout {
    CGSize contentSize;
    
    NSMutableArray *sectionDurations;
    NSMutableArray *sectionCounts;
    NSMutableArray *sectionRects;
    NSMutableArray *cellRects;
    
    float maximumDuration;
    float durationScale;
    float totalCount;

    }

// prepareLayout tasks
//      Create an array of the total duration lengths for each of the sections
//      Find the total duration length (max duration length)
//      Set the durationScale
//      Set the content size

// V2
//      create an array of centerpoints for each cell within each section frame
//      store the rect size and max duration for each section

-(void)prepareLayout {
    durationScale = 1;
    sectionDurations = [NSMutableArray array];
    cellRects = [NSMutableArray array];
    sectionRects = [NSMutableArray array];
    maximumDuration = 0;
    totalCount = 0;
    float sectionYOffset = 0;
    
    id<TasksViewDelegateLayout> delegate = (id<TasksViewDelegateLayout>)self.collectionView.delegate;

    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++){
        float lastPosition = 0;
        float countInSection = 0;
        float currentCellWidth = 0;
        float lastCellWidth = 0;
        float startPosition = 0;
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:[self.collectionView numberOfItemsInSection:section]];
        
        // Find total duration for each section
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section] ; item++) {
           
            // Get whether current cell is sequential
            
            BOOL sequential = [delegate sequentialForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            

            // Get current cell width
             currentCellWidth = [delegate widthForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            
            // Set start position of current cell
            if (!sequential) {
                if (currentCellWidth > lastCellWidth) {
                    startPosition = lastPosition - lastCellWidth;
                    lastPosition = lastPosition + (currentCellWidth - lastCellWidth);
                } else {
                    startPosition = lastPosition - currentCellWidth;
                }
            } else {
                startPosition = lastPosition;
            }
            
            // Create the cell frame and add to array
            CGRect rect = CGRectMake(startPosition, countInSection * ITEM_SIZE, currentCellWidth, ITEM_SIZE);
            NSValue* tempValue = [NSValue valueWithCGRect:rect];
            [array addObject:tempValue];
            
//            currentCellWidth = MAX(currentCellWidth, lastCellWidth);
            lastPosition = !(sequential) ? lastPosition :  lastPosition + currentCellWidth;
            lastCellWidth = currentCellWidth;
            countInSection += 1;
            
            
            if (!sequential) {
            //    lastCellWidth = MIN(currentCellWidth, lastCellWidth);
            }
            
        }
        // add array of frame rects
        [cellRects addObject:array];

        totalCount += countInSection;
        
        // find maximum section duration
        maximumDuration = MAX(lastPosition, maximumDuration);
        
        //add section duration to array of durations
        NSNumber* tempDuration = [NSNumber numberWithFloat:lastPosition];
        [sectionDurations addObject:tempDuration];
        
        //add section count to array of counts
        NSNumber* tempCount = [NSNumber numberWithFloat:countInSection];
        [sectionCounts addObject:tempCount];
        
        //add section rect to array of rects
        CGRect rect = CGRectMake(0, sectionYOffset + ITEM_SIZE, lastPosition * durationScale, ITEM_SIZE * countInSection);
        sectionYOffset += ITEM_SIZE * countInSection + ITEM_SIZE;
        
        NSValue* tempRect = [NSValue valueWithCGRect:rect];
        [sectionRects addObject:tempRect];
        
    }
    //set total content size
    contentSize = CGSizeMake(MAX(durationScale * maximumDuration , self.collectionView.frame.size.width), (ITEM_SIZE * totalCount + [self.collectionView numberOfSections] * ITEM_SIZE));
    
    for (int section = 0; section < sectionRects.count; section++) {
        CGRect tempRect = [[sectionRects objectAtIndex:section] CGRectValue];
        tempRect = CGRectOffset(tempRect, contentSize.width - [(NSNumber*)[sectionDurations objectAtIndex:section] floatValue] - ITEM_SIZE, 0);
        NSValue* tempValue = [NSNumber valueWithCGRect:tempRect];
        [sectionRects replaceObjectAtIndex:section withObject:tempValue];
    }
}

#pragma mark - UICollectionViewFlowLayoutDelegate methods

/*
 - (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)theIndexPath {
 UICollectionViewLayoutAttributes *theLayoutAttributes = [super layoutAttributesForItemAtIndexPath:theIndexPath];
 
 switch (theLayoutAttributes.representedElementCategory) {
 case UICollectionElementCategoryCell: {
 [self applyLayoutAttributes:theLayoutAttributes];
 } break;
 default: {
 } break;
 }
 
 return theLayoutAttributes;
 
 }
 
 */

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect sectionRect = [sectionRects[indexPath.section] CGRectValue];
    CGRect cellRect = [[[cellRects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CGRectValue];
    
    attributes.size = CGSizeMake(cellRect.size.width, ITEM_SIZE);
    attributes.center = CGPointMake(CGRectGetMinX(sectionRect) + cellRect.origin.x + cellRect.size.width / 2, CGRectGetMinY(sectionRect) + cellRect.origin.y + cellRect.size.height/2);
        
    return attributes;
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    CGRect sectionRect = [sectionRects[indexPath.section] CGRectValue];
    float sectionWidth = MAX(durationScale * maximumDuration , self.collectionView.frame.size.width);
    
    attributes.size = CGSizeMake(sectionWidth * 2, sectionRect.size.height + (ITEM_SIZE * 0.75));
    attributes.center = CGPointMake(sectionWidth / 2, sectionRect.origin.y + sectionRect.size.height/2);
    attributes.zIndex = -100;
    
    return attributes;
}

-(CGSize) collectionViewContentSize {
    return contentSize;
}
/*
- (CGSize)collectionViewContentSize {
    CGSize theCollectionViewContentSize = [super collectionViewContentSize];
    if (self.alwaysScroll) {
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionVertical: {
                if (theCollectionViewContentSize.height <= CGRectGetHeight(self.collectionView.bounds)) {
                    theCollectionViewContentSize.height = CGRectGetHeight(self.collectionView.bounds) + 1.0f;
                }
            } break;
            case UICollectionViewScrollDirectionHorizontal: {
                if (theCollectionViewContentSize.width <= CGRectGetWidth(self.collectionView.bounds)) {
                    theCollectionViewContentSize.width = CGRectGetWidth(self.collectionView.bounds) + 1.0f;
                }
            } break;
        }
    }
    return theCollectionViewContentSize;
}
*/


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // add a filter fopr elements - first if the section rect is in view - then the specific tasks
    
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger row=0 ; row < [self.collectionView numberOfItemsInSection:section] ; row++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
        [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]];
    }
    return attributes;
}

/*
 - (NSArray *)layoutAttributesForElementsInRect:(CGRect)theRect {
 NSArray *theLayoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:theRect];
 
 for (UICollectionViewLayoutAttributes *theLayoutAttributes in theLayoutAttributesForElementsInRect) {
 switch (theLayoutAttributes.representedElementCategory) {
 case UICollectionElementCategoryCell: {
 [self applyLayoutAttributes:theLayoutAttributes];
 } break;
 default: {
 } break;
 }
 }
 
 return theLayoutAttributesForElementsInRect;
 }
 */



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

#pragma mark -
#pragma mark Reorderable Methods

- (void)setUpGestureRecognizersOnCollectionView {
    UILongPressGestureRecognizer *theLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    // Links the default long press gesture recognizer to the custom long press gesture recognizer we are creating now
    // by enforcing failure dependency so that they doesn't clash.
    for (UIGestureRecognizer *theGestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([theGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [theGestureRecognizer requireGestureRecognizerToFail:theLongPressGestureRecognizer];
        }
    }
    theLongPressGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:theLongPressGestureRecognizer];
    self.longPressGestureRecognizer = theLongPressGestureRecognizer;
    
    UIPanGestureRecognizer *thePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    thePanGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:thePanGestureRecognizer];
    self.panGestureRecognizer = thePanGestureRecognizer;
    
    self.triggerScrollingEdgeInsets = UIEdgeInsetsMake(100.0f, 100.0f, 100.0f, 100.0f);
    self.scrollingSpeed = 1500.0f;
    [self.scrollingTimer invalidate];
    self.scrollingTimer = nil;
    self.alwaysScroll = YES;
}

- (void)awakeFromNib {
    [self setUpGestureRecognizersOnCollectionView];
}

#pragma mark - Custom methods

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)theLayoutAttributes {
    if ([theLayoutAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
        theLayoutAttributes.hidden = YES;
    }
}

- (void)invalidateLayoutIfNecessary {
    NSIndexPath *theIndexPathOfSelectedItem = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
    if ((![theIndexPathOfSelectedItem isEqual:self.selectedItemIndexPath]) &&(theIndexPathOfSelectedItem)) {
        NSIndexPath *thePreviousSelectedIndexPath = self.selectedItemIndexPath;
        self.selectedItemIndexPath = theIndexPathOfSelectedItem;
        if ([self.collectionView.delegate conformsToProtocol:@protocol(TasksViewDelegateLayout)]) {
            id<TasksViewDelegateLayout> theDelegate = (id<TasksViewDelegateLayout>)self.collectionView.delegate;
            [theDelegate collectionView:self.collectionView layout:self itemAtIndexPath:thePreviousSelectedIndexPath willMoveToIndexPath:theIndexPathOfSelectedItem];
        }
        [self.collectionView performBatchUpdates:^{
            [self.collectionView moveItemAtIndexPath:thePreviousSelectedIndexPath toIndexPath:theIndexPathOfSelectedItem];
            [self.collectionView deleteItemsAtIndexPaths:@[ thePreviousSelectedIndexPath ]];
            [self.collectionView insertItemsAtIndexPaths:@[ theIndexPathOfSelectedItem ]];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Target/Action methods

- (void)handleScroll:(NSTimer *)theTimer {
    LXReorderableCollectionViewFlowLayoutScrollingDirection theScrollingDirection = (LXReorderableCollectionViewFlowLayoutScrollingDirection)[theTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue];
    switch (theScrollingDirection) {
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionUp: {
            CGFloat theDistance = -(self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMinY = 0.0f;
            if ((theContentOffset.y + theDistance) <= theMinY) {
                theDistance = -theContentOffset.y;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(0.0f, theDistance));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(0.0f, theDistance));
            self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionDown: {
            CGFloat theDistance = (self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMaxY = MAX(self.collectionView.contentSize.height, CGRectGetHeight(self.collectionView.bounds)) - CGRectGetHeight(self.collectionView.bounds);
            if ((theContentOffset.y + theDistance) >= theMaxY) {
                theDistance = theMaxY - theContentOffset.y;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(0.0f, theDistance));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(0.0f, theDistance));
            self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
            
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft: {
            CGFloat theDistance = -(self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMinX = 0.0f;
            if ((theContentOffset.x + theDistance) <= theMinX) {
                theDistance = -theContentOffset.x;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(theDistance, 0.0f));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(theDistance, 0.0f));
            self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionRight: {
            CGFloat theDistance = (self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMaxX = MAX(self.collectionView.contentSize.width, CGRectGetWidth(self.collectionView.bounds)) - CGRectGetWidth(self.collectionView.bounds);
            if ((theContentOffset.x + theDistance) >= theMaxX) {
                theDistance = theMaxX - theContentOffset.x;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(theDistance, 0.0f));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(theDistance, 0.0f));
            self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
            
        default: {
        } break;
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)theLongPressGestureRecognizer {
    switch (theLongPressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            CGPoint theLocationInCollectionView = [theLongPressGestureRecognizer locationInView:self.collectionView];
            NSIndexPath *theIndexPathOfSelectedItem = [self.collectionView indexPathForItemAtPoint:theLocationInCollectionView];
            
            if ([self.collectionView.delegate conformsToProtocol:@protocol(TasksViewDelegateLayout)]) {
                id<TasksViewDelegateLayout> theDelegate = (id<TasksViewDelegateLayout>)self.collectionView.delegate;
                if ([theDelegate respondsToSelector:@selector(collectionView:layout:willBeginReorderingAtIndexPath:)]) {
                    [theDelegate collectionView:self.collectionView layout:self willBeginReorderingAtIndexPath:theIndexPathOfSelectedItem];
                }
            }
            
            UICollectionViewCell *theCollectionViewCell = [self.collectionView cellForItemAtIndexPath:theIndexPathOfSelectedItem];
            
            theCollectionViewCell.highlighted = YES;
            
            UIGraphicsBeginImageContextWithOptions(theCollectionViewCell.bounds.size, NO, 0.0f);
            [theCollectionViewCell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *theHighlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            theCollectionViewCell.highlighted = NO;
            UIGraphicsBeginImageContextWithOptions(theCollectionViewCell.bounds.size, NO, 0.0f);
            [theCollectionViewCell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView *theImageView = [[UIImageView alloc] initWithImage:theImage];
            theImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // Not using constraints, lets auto resizing mask be translated automatically...
            
            UIImageView *theHighlightedImageView = [[UIImageView alloc] initWithImage:theHighlightedImage];
            theHighlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // Not using constraints, lets auto resizing mask be translated automatically...
            
            UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(theCollectionViewCell.frame), CGRectGetMinY(theCollectionViewCell.frame), CGRectGetWidth(theImageView.frame), CGRectGetHeight(theImageView.frame))];
            
            [theView addSubview:theImageView];
            [theView addSubview:theHighlightedImageView];
            
            [self.collectionView addSubview:theView];
            
            self.selectedItemIndexPath = theIndexPathOfSelectedItem;
            self.currentView = theView;
            self.currentViewCenter = theView.center;
            
            theImageView.alpha = 0.0f;
            theHighlightedImageView.alpha = 1.0f;
            
            [UIView
             animateWithDuration:0.1
             animations:^{
                 theView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                 theImageView.alpha = 1.0f;
                 theHighlightedImageView.alpha = 0.0f;
             }
             completion:^(BOOL finished) {
                 [theHighlightedImageView removeFromSuperview];
                 
                 if ([self.collectionView.delegate conformsToProtocol:@protocol(TasksViewDelegateLayout)]) {
                     id<TasksViewDelegateLayout> theDelegate = (id<TasksViewDelegateLayout>)self.collectionView.delegate;
                     if ([theDelegate respondsToSelector:@selector(collectionView:layout:didBeginReorderingAtIndexPath:)]) {
                         [theDelegate collectionView:self.collectionView layout:self didBeginReorderingAtIndexPath:theIndexPathOfSelectedItem];
                     }
                 }
                 NSLog(@"Finished animation");
             }];
            
            [self invalidateLayout];
        } break;
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *theIndexPathOfSelectedItem = self.selectedItemIndexPath;
            
            if ([self.collectionView.delegate conformsToProtocol:@protocol(TasksViewDelegateLayout)]) {
                id<TasksViewDelegateLayout> theDelegate = (id<TasksViewDelegateLayout>)self.collectionView.delegate;
                if ([theDelegate respondsToSelector:@selector(collectionView:layout:willEndReorderingAtIndexPath:)]) {
                    [theDelegate collectionView:self.collectionView layout:self willEndReorderingAtIndexPath:theIndexPathOfSelectedItem];
                }
            }
            
            self.selectedItemIndexPath = nil;
            self.currentViewCenter = CGPointZero;
            
            UICollectionViewLayoutAttributes *theLayoutAttributes = [self layoutAttributesForItemAtIndexPath:theIndexPathOfSelectedItem];
            [self.currentView removeFromSuperview];
            [self invalidateLayout];
            __weak TasksViewLayout *theWeakSelf = self;
            [UIView
             animateWithDuration:0.3f
             animations:^{
                 __strong TasksViewLayout *theStrongSelf = theWeakSelf;
                 
                 theStrongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                 theStrongSelf.currentView.center = theLayoutAttributes.center;
             }
             completion:^(BOOL finished) {
                 __strong TasksViewLayout *theStrongSelf = theWeakSelf;
                 
                 [theStrongSelf.currentView removeFromSuperview];
                 [theStrongSelf invalidateLayout];
                 
                 if ([self.collectionView.delegate conformsToProtocol:@protocol(TasksViewDelegateLayout)]) {
                     id<TasksViewDelegateLayout> theDelegate = (id<TasksViewDelegateLayout>)self.collectionView.delegate;
                     if ([theDelegate respondsToSelector:@selector(collectionView:layout:didEndReorderingAtIndexPath:)]) {
                         [theDelegate collectionView:self.collectionView layout:self didEndReorderingAtIndexPath:theIndexPathOfSelectedItem];
                     }
                 }
             }];
        } break;
        default: {
        } break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)thePanGestureRecognizer {
    switch (thePanGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            
        case UIGestureRecognizerStateChanged: {
            CGPoint theTranslationInCollectionView = [thePanGestureRecognizer translationInView:self.collectionView];
            self.panTranslationInCollectionView = theTranslationInCollectionView;
            CGPoint theLocationInCollectionView = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
            self.currentView.center = theLocationInCollectionView;
            
            [self invalidateLayoutIfNecessary];
            
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    if (theLocationInCollectionView.y < (CGRectGetMinY(self.collectionView.bounds) + self.triggerScrollingEdgeInsets.top)) {
                        BOOL isScrollingTimerSetUpNeeded = YES;
                        if (self.scrollingTimer) {
                            if (self.scrollingTimer.isValid) {
                                isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionUp);
                            }
                        }
                        if (isScrollingTimerSetUpNeeded) {
                            if (self.scrollingTimer) {
                                [self.scrollingTimer invalidate];
                                self.scrollingTimer = nil;
                            }
                            self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                                   target:self
                                                                                 selector:@selector(handleScroll:)
                                                                                 userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionUp ) }
                                                                                  repeats:YES];
                        }
                    } else if (theLocationInCollectionView.y > (CGRectGetMaxY(self.collectionView.bounds) - self.triggerScrollingEdgeInsets.bottom)) {
                        BOOL isScrollingTimerSetUpNeeded = YES;
                        if (self.scrollingTimer) {
                            if (self.scrollingTimer.isValid) {
                                isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionDown);
                            }
                        }
                        if (isScrollingTimerSetUpNeeded) {
                            if (self.scrollingTimer) {
                                [self.scrollingTimer invalidate];
                                self.scrollingTimer = nil;
                            }
                            self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                                   target:self
                                                                                 selector:@selector(handleScroll:)
                                                                                 userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionDown ) }
                                                                                  repeats:YES];
                        }
                    } else {
                        if (self.scrollingTimer) {
                            [self.scrollingTimer invalidate];
                            self.scrollingTimer = nil;
                        }
                    }
                } break;
                case UICollectionViewScrollDirectionHorizontal: {
                    if (theLocationInCollectionView.x < (CGRectGetMinX(self.collectionView.bounds) + self.triggerScrollingEdgeInsets.left)) {
                        BOOL isScrollingTimerSetUpNeeded = YES;
                        if (self.scrollingTimer) {
                            if (self.scrollingTimer.isValid) {
                                isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft);
                            }
                        }
                        if (isScrollingTimerSetUpNeeded) {
                            if (self.scrollingTimer) {
                                [self.scrollingTimer invalidate];
                                self.scrollingTimer = nil;
                            }
                            self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                                   target:self
                                                                                 selector:@selector(handleScroll:)
                                                                                 userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft ) }
                                                                                  repeats:YES];
                        }
                    } else if (theLocationInCollectionView.x > (CGRectGetMaxX(self.collectionView.bounds) - self.triggerScrollingEdgeInsets.right)) {
                        BOOL isScrollingTimerSetUpNeeded = YES;
                        if (self.scrollingTimer) {
                            if (self.scrollingTimer.isValid) {
                                isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionRight);
                            }
                        }
                        if (isScrollingTimerSetUpNeeded) {
                            if (self.scrollingTimer) {
                                [self.scrollingTimer invalidate];
                                self.scrollingTimer = nil;
                            }
                            self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                                   target:self
                                                                                 selector:@selector(handleScroll:)
                                                                                 userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionRight ) }
                                                                                  repeats:YES];
                        }
                    } else {
                        if (self.scrollingTimer) {
                            [self.scrollingTimer invalidate];
                            self.scrollingTimer = nil;
                        }
                    }
                } break;
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            if (self.scrollingTimer) {
                [self.scrollingTimer invalidate];
                self.scrollingTimer = nil;
            }
        } break;
        default: {
        } break;
    }
}


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)theGestureRecognizer {
    NSLog(@"recognizer should begin");
    if ([self.panGestureRecognizer isEqual:theGestureRecognizer]) {
        return (self.selectedItemIndexPath != nil);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)theGestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)theOtherGestureRecognizer {
    if ([self.longPressGestureRecognizer isEqual:theGestureRecognizer]) {
        if ([self.panGestureRecognizer isEqual:theOtherGestureRecognizer]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([self.panGestureRecognizer isEqual:theGestureRecognizer]) {
        if ([self.longPressGestureRecognizer isEqual:theOtherGestureRecognizer]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

@end
