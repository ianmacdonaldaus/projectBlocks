//
//  Project.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ColorPalette, Section;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) ColorPalette *colorPalette;
@property (nonatomic, retain) NSSet *section;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addSectionObject:(Section *)value;
- (void)removeSectionObject:(Section *)value;
- (void)addSection:(NSSet *)values;
- (void)removeSection:(NSSet *)values;

@end
