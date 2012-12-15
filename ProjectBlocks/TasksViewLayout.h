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

@protocol CollectionViewDelegateTaskViewLayout <UICollectionViewDelegate>
@optional

- (CGFloat)widthForItemAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL)sequentialForItemAtIndexPath:(NSIndexPath*)indexPath;


@end


@interface TasksViewLayout : UICollectionViewLayout

@end
