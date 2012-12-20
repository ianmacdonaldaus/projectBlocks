//
//  TaskViewCell.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 25/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TaskViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TaskViewCell {
    CAGradientLayer *_gradientLayer;
}

@synthesize taskLabel;
@synthesize durationLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.alpha = 0.5;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.shadowOpacity = 0.3;
        self.contentView.layer.shadowOffset = CGSizeMake(3, 3);
        self.contentView.layer.shadowRadius = 5;
        //self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.shouldRasterize = YES;
        self.contentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        
        taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, frame.size.width - 10, 20)];
        taskLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:14];
        taskLabel.textColor = [UIColor whiteColor];
        taskLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        taskLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:taskLabel];
        
        durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height - 20, frame.size.width - 10, 20)];
        durationLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:11];
        durationLabel.textColor = [UIColor whiteColor];
        durationLabel.backgroundColor = [UIColor clearColor];
        durationLabel.textAlignment = NSTextAlignmentRight;
        durationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:durationLabel];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.cornerRadius = 5;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
        (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
        (id)[[UIColor clearColor] CGColor],
        (id)[[UIColor colorWithWhite:0.3f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f,@0.8f,@1.00f];
        [self.contentView.layer addSublayer:_gradientLayer];


    }
    return self;
}

-(void)layoutSubviews {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _gradientLayer.frame = self.bounds;
    [CATransaction commit];
}

@end
