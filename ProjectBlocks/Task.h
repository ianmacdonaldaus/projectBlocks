//
//  Task.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, TaskImage;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * duration;
@property (nonatomic, retain) NSNumber * durationMinutes;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * sequential;
@property (nonatomic, retain) NSDate * timeToFinish;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleDetail;
@property (nonatomic, retain) TaskImage *taskImage;
@property (nonatomic, retain) Section *section;

- (NSString *)getTaskDurationAsString;
- (BOOL)sequentialForItemAtIndexPath;

@end
