//
//  TaskDetailView.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 12/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Task.h"

@interface TaskDetailView : UIViewController {
    NSManagedObjectContext *managedObjectContext;
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) Task *task;
@property (strong, nonatomic) IBOutlet UITextView *taskDetailTextView;
@property (strong, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (strong, nonatomic) UIColor *detailViewColor;

@end
