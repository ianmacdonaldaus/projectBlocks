//
//  CVViewController.h
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksViewLayout.h"
#import "CoreDataCollectionViewController.h"
#import "Project.h"
#import "ColorPalette.h"


@interface TasksViewController : CoreDataCollectionViewController <CollectionViewDelegateTaskViewLayout, UIScrollViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegate> {

    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Project* project;
@property (strong, nonatomic) ColorPalette* colorPalette;
@property (nonatomic, assign) NSInteger cellCount;

@end
