//
//  CVLayout.m
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TasksViewLayout.h"
#import <QuartzCore/QuartzCore.h>

#define ITEM_SIZE 40

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
    
    id<CollectionViewDelegateTaskViewLayout> delegate = (id<CollectionViewDelegateTaskViewLayout>)self.collectionView.delegate;

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
        
//        NSLog(@"%@", tempDuration);
//        NSLog(@"%@", tempCount);
//        NSLog(@"%@", tempRect);
        
        
    }
    //set total content size
    contentSize = CGSizeMake(MAX(durationScale * maximumDuration , self.collectionView.frame.size.width), (ITEM_SIZE * totalCount + [self.collectionView numberOfSections] * ITEM_SIZE));
//    NSLog(@"content Size %f",contentSize.width);
    
    for (int section = 0; section < sectionRects.count; section++) {
        CGRect tempRect = [[sectionRects objectAtIndex:section] CGRectValue];
        tempRect = CGRectOffset(tempRect, contentSize.width - [(NSNumber*)[sectionDurations objectAtIndex:section] floatValue] - ITEM_SIZE, 0);
        NSValue* tempValue = [NSNumber valueWithCGRect:tempRect];
        [sectionRects replaceObjectAtIndex:section withObject:tempValue];
    }
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //NSLog(@"section %i - row %i",indexPath.section, indexPath.row);
    CGRect sectionRect = [sectionRects[indexPath.section] CGRectValue];
    CGRect cellRect = [[[cellRects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CGRectValue];
    
    attributes.size = CGSizeMake(cellRect.size.width, ITEM_SIZE);
    attributes.center = CGPointMake(CGRectGetMinX(sectionRect) + cellRect.origin.x + cellRect.size.width / 2, CGRectGetMinY(sectionRect) + cellRect.origin.y + cellRect.size.height/2);
    
//    NSLog(@"section %i row %i size %@ center %@",indexPath.section,indexPath.row,NSStringFromCGSize(attributes.size), NSStringFromCGPoint(attributes.center));
    
    return attributes;
                                                    
}

-(CGSize) collectionViewContentSize {
    return contentSize;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger row=0 ; row < [self.collectionView numberOfItemsInSection:section] ; row++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

/*

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *update in updateItems)
    {
        if (update.updateAction == UICollectionUpdateActionDelete)
        {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        }
        else if (update.updateAction == UICollectionUpdateActionInsert)
        {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    // release the insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

// Note: name of method changed
// Also this gets called for all visible cells (not just the inserted ones) and
// even gets called when deleting cells!
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPaths containsObject:itemIndexPath])
    {
        // only change attributes on inserted cells
        if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(0, 0);
    }
    
    return attributes;
}

// Note: name of method changed
// Also this gets called for all visible cells (not just the deleted ones) and
// even gets called when inserting cells!
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath])
    {
        // only change attributes on deleted cells
        if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(0, 0);
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
 
    return attributes;
}
 */

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}


@end
