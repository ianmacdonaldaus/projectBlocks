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


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect sectionRect = [sectionRects[indexPath.section] CGRectValue];
    CGRect cellRect = [[[cellRects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CGRectValue];
    
    attributes.size = CGSizeMake(cellRect.size.width, ITEM_SIZE);
    attributes.center = CGPointMake(CGRectGetMinX(sectionRect) + cellRect.origin.x + cellRect.size.width / 2, CGRectGetMinY(sectionRect) + cellRect.origin.y + cellRect.size.height/2);
        
    return attributes;
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
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



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}


@end
