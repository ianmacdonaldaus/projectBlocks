//
//  ColorPalette.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Colors, Project;

@interface ColorPalette : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *colors;
@property (nonatomic, retain) NSSet *project;
@end

@interface ColorPalette (CoreDataGeneratedAccessors)

- (void)addColorsObject:(Colors *)value;
- (void)removeColorsObject:(Colors *)value;
- (void)addColors:(NSSet *)values;
- (void)removeColors:(NSSet *)values;

- (void)addProjectObject:(Project *)value;
- (void)removeProjectObject:(Project *)value;
- (void)addProject:(NSSet *)values;
- (void)removeProject:(NSSet *)values;

@end
