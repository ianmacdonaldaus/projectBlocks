//
//  TasksViewSectionDecorationView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 05/02/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//

#import "TasksViewSectionDecorationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TasksViewSectionDecorationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0;
//        self.contentView.layer.opacity = 0.25;
//        self.contentView.backgroundColor = [UIColor redColor];

        
    }
    return self;
}

@end
