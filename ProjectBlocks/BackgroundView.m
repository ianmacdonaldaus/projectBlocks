//
//  BackgroundView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 16/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "BackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BackgroundView
{
    CAGradientLayer *gradientLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subtle-pattern-7.jpg"]];
        backgroundView.frame = frame;
        backgroundView.layer.opacity = 1.0;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = frame;
        
        gradientLayer.colors = @[
        (id)[[UIColor clearColor] CGColor],
        (id)[[UIColor colorWithWhite:0.0f alpha:0.15f] CGColor],
        (id)[[UIColor colorWithWhite:0.0f alpha:0.3f] CGColor]];
        gradientLayer.locations = @[@0.50f, @0.8f,@1.00f];
        [self.layer addSublayer:gradientLayer];
        
        self.backgroundColor = [UIColor blackColor];
        [self insertSubview:backgroundView atIndex:0];

    }
    return self;
}

-(void) layoutSubviews {
    gradientLayer.frame = self.bounds;
}


@end
