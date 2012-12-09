//
//  TaskViewCell.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 25/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TaskViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TaskViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.alpha = 0.5;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.shadowOpacity = 0.5;
        self.contentView.layer.shadowOffset = CGSizeMake(5, 5);
        self.contentView.layer.shadowRadius = 2;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.shouldRasterize = YES;
    }
    return self;
}


@end
