//
//  Section.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Task;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *task;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)values;
- (void)removeTask:(NSSet *)values;

@end
