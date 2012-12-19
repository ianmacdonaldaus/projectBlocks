//
//  Project.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ColorPalette, Task;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) ColorPalette *colorPalette;
@property (nonatomic, retain) NSSet *task;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)values;
- (void)removeTask:(NSSet *)values;

@end
