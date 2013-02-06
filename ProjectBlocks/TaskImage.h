//
//  TaskImage.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskImage : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Task *task;

@end
