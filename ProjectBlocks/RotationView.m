//
//  RotationView.m
//  Blocks
//
//  Created by Ian MacDonald on 22/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "RotationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 20;
        self.layer.shouldRasterize = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect holeRect = CGRectMake(self.bounds.size.width / 2 - 25, 25, 50, 50);
    
    CGContextSetFillColorWithColor( context, [UIColor colorWithWhite:0.9 alpha:1.0].CGColor );
    CGContextFillEllipseInRect( context, rect );
    
    CGContextSetFillColorWithColor( context, [UIColor colorWithWhite:1.0 alpha:1.0].CGColor );
    CGContextFillEllipseInRect( context, holeRect );
    
}

@end
