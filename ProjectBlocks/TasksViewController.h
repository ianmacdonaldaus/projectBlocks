//
//  CVViewController.h
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksViewLayout.h"

@interface TasksViewController : UICollectionViewController <CollectionViewDelegateTaskViewLayout, UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {

    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) NSInteger cellCount;

@end
