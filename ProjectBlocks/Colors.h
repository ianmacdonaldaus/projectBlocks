//
//  Colors.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ColorPalette;

@interface Colors : NSManagedObject

@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) ColorPalette *colorPalette;

@end
