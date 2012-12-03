//
//  Section.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 02/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Task;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSNumber * colourEnd;
@property (nonatomic, retain) NSNumber * colourStart;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *task;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)values;
- (void)removeTask:(NSSet *)values;

@end
