//
//  ProjectsViewController.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 01/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ProjectsViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UIPopoverControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    UIPopoverController *detailPopOver;
}


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *detailPopOver;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@end
