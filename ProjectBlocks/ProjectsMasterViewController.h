//
//  ProjectsMasterViewController.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 11/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataCollectionViewController.h"

@interface ProjectsMasterViewController : CoreDataCollectionViewController <UIPopoverControllerDelegate, UICollectionViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *detailPopOver;


@end
