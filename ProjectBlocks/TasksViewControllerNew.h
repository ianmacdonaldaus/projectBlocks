//
//  TaskViewControllerNew.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 19/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksViewLayout.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "CoreDataCollectionViewController.h"
#import "Project.h"
#import "ColorPalette.h"


@interface TasksViewControllerNew : UICollectionViewController <TasksViewDelegateLayout, UIScrollViewDelegate, UICollectionViewDelegate>

@property (strong, nonatomic) Project* project;
@property (strong, nonatomic) ColorPalette* colorPalette;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, strong) NSMutableArray* arrayOfTasks;
@property (nonatomic, strong) NSMutableArray* arrayOfSections;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
