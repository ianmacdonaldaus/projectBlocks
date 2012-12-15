//
//  Task.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 12/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Section, TaskImage;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * duration;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * sequential;
@property (nonatomic, retain) NSDate * timeToFinish;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleDetail;
@property (nonatomic, retain) NSNumber * durationMinutes;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) TaskImage *taskImage;

@end
