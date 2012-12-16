//
//  ProjectViewCell.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 10/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProjectViewCell {
    CAGradientLayer *_gradientLayer;
}

@synthesize projectTitle = _projectTitle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView.layer.cornerRadius = 15;
        self.contentView.clipsToBounds = YES;

        /*
         UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [button setCenter:CGPointMake(cell.frame.size.width - 20, 25)];
        [button showsTouchWhenHighlighted];
        [button setTag:indexPath.row];
        [button addTarget:self action:@selector(popOver:) forControlEvents:UIControlEventTouchUpInside];
         [cell addSubview:button];
         */
        
        float layerHeight[5] = {65,8,3,5,20};
        float layerColourRed[5] = {0.0392 , 0.1098 , 0.9882 , 0.9843 , 0.7922} ;
        float layerColourGreen[5] = {0.0745 , 0.5019 , 0.9686 , 0.9254 , 0.6627};
        float layerColourBlue[5] = {0.2392 , 0.5294 , 0.8784 , 0.1960 , 0.1372};
        float startHeight = 0;
        for (int i=0; i<5; i++) {
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [[UIColor colorWithRed:layerColourRed[i] green:layerColourGreen[i] blue:layerColourBlue[i] alpha:1.0f] CGColor];
            layer.frame = CGRectMake(0, startHeight, frame.size.width, frame.size.height * layerHeight[i]/100);
            [self.contentView.layer addSublayer:layer];
            startHeight += frame.size.height * layerHeight[i]/100;
        }
        

        _projectTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width - 20, 40)];
        _projectTitle.textAlignment = NSTextAlignmentLeft;
        _projectTitle.backgroundColor = [UIColor clearColor];
        _projectTitle.textColor = [UIColor whiteColor];
        _projectTitle.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:24];
        [self.contentView addSubview:_projectTitle];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
        (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
        (id)[[UIColor clearColor] CGColor],
        (id)[[UIColor colorWithWhite:0.3f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f,@0.8f,@1.00f];
        [self.contentView.layer addSublayer:_gradientLayer];

    }
    return self;
}

@end
