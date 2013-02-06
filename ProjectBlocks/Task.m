//
//  Task.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import "Task.h"
#import "Section.h"
#import "TaskImage.h"


@implementation Task

@dynamic completed;
@dynamic duration;
@dynamic durationMinutes;
@dynamic index;
@dynamic sequential;
@dynamic timeToFinish;
@dynamic title;
@dynamic titleDetail;
@dynamic taskImage;
@dynamic section;

-(NSString *)getTaskDurationAsString{
    
    NSString *durationText;
    
    float durationHours = floorf([self.durationMinutes floatValue] / 60);
    
    float durationMinutes = [self.durationMinutes floatValue] - (durationHours * 60);
    
    if (durationHours> 0) {
        
        durationText = [NSString stringWithFormat:@"%1.0fh %1.0fm",durationHours, durationMinutes];
        
    } else {
        
        durationText = [NSString stringWithFormat:@"%1.0fm", durationMinutes];
        
    }
    
    return durationText;
    
}



- (BOOL)sequentialForItemAtIndexPath {
    
    BOOL sequential = [self.sequential boolValue];
    
    return sequential;
    
}


@end
