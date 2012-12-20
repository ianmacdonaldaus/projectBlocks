//
//  TaskEditModalView.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 19/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalView.h"
#import "Task.h"

@interface TaskEditModalView : ModalView

@property (nonatomic, retain) Task *task;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
