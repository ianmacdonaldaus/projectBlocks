//
//  Task.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "Task.h"
#import "Project.h"
#import "TaskImage.h"


@implementation Task

@dynamic completed;
@dynamic duration;
@dynamic durationMinutes;
@dynamic index;
@dynamic section;
@dynamic sequential;
@dynamic timeToFinish;
@dynamic title;
@dynamic titleDetail;
@dynamic project;
@dynamic taskImage;

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

@end
