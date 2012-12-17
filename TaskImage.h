//
//  TaskImage.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 16/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskImage : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Task *task;

@end
