//
//  TasksViewSectionSupplementaryCell.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 20/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TasksViewSectionSupplementaryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TasksViewSectionSupplementaryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.opacity = 0.25;
        //self.layer.shouldRasterize = NO;
        //self.opaque = NO;
        self.contentView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)willMoveToWindow:(UIWindow *)newWindow {
    //self.layer.opacity = 0.25;
    //self.layer.shouldRasterize = NO;
    //self.opaque = NO;
}

@end
