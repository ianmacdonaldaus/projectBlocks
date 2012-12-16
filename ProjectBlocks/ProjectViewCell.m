//
//  ProjectViewCell.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 10/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProjectViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer * layer1 = [CALayer layer];
        layer1.frame = frame;
        layer1.backgroundColor = [[UIColor colorWithRed:0.0392f green:0.0745f blue:0.2392f alpha:1.0f] CGColor];
        [self.contentView.layer addSublayer:layer1];
    }
    return self;
}
@end
