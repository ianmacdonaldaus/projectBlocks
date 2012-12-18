//
//  ColorPalette.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface ColorPalette : NSManagedObject

@property (nonatomic, retain) id color1;
@property (nonatomic, retain) id color2;
@property (nonatomic, retain) id color3;
@property (nonatomic, retain) id color4;
@property (nonatomic, retain) id color5;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *project;
@end

@interface ColorPalette (CoreDataGeneratedAccessors)

- (void)addProjectObject:(Project *)value;
- (void)removeProjectObject:(Project *)value;
- (void)addProject:(NSSet *)values;
- (void)removeProject:(NSSet *)values;

@end
