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
    NSMutableArray *_arrayOfColourLayers;
}

@synthesize projectTitle = _projectTitle;
@synthesize colorPalette = _colorPalette;


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
        (id)[[UIColor colorWithWhite:0.0f alpha:0.3f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f,@0.8f,@1.00f];
        [self.contentView.layer insertSublayer:_gradientLayer atIndex:10];

        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 10;
        self.layer.shadowOffset = CGSizeMake(7, 7);
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        //cell.clipsToBounds = NO;
        float startHeight = 0;
        float layerHeight[5] = {40,15,15,15,15};

        for (int i = 0; i<5; i++) {
            CALayer *colorPaletteLayer = [CALayer layer];
            colorPaletteLayer.frame = CGRectMake(0, startHeight, self.frame.size.width, self.frame.size.height * layerHeight[i]/100);
            colorPaletteLayer.backgroundColor = [[UIColor colorWithHue:i/5.0f saturation:1 brightness:1 alpha:1] CGColor];
            [self.contentView.layer insertSublayer:colorPaletteLayer atIndex:0];
            
            startHeight += self.frame.size.height * layerHeight[i]/100;
            [_arrayOfColourLayers addObject:colorPaletteLayer];
        }

    }
    return self;
}

-(void)setColorPalette:(ColorPalette *)colorPalette{    
    int i = 4;
    for (CALayer *layer in self.contentView.layer.sublayers) {
        NSString *string = [NSString stringWithFormat:@"color%i",i+1];
        SEL s = NSSelectorFromString(string);
        if ([colorPalette respondsToSelector:s]) {
            layer.backgroundColor = [[colorPalette performSelector:s] CGColor];
        }
        i -= 1;

    }
    
}

@end
