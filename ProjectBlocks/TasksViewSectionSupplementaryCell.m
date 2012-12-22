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
        // Initialization code
    }
    return self;
}

-(void)willMoveToWindow:(UIWindow *)newWindow {
    self.layer.backgroundColor = [self.backgroundPaletteColor CGColor];
    self.layer.opacity = 0.5;
    self.layer.cornerRadius = 5;
}

@end
