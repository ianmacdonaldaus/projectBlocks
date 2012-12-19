//
//  ModalView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ModalView.h"

static float cornerRadius = 15;
@implementation ModalView

@synthesize backgroundView = _backgroundView;
@synthesize editView = _editView;
@synthesize gradientLayer = _gradientLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
//        _backgroundView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.layer.opacity = 0.65;
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];

        _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
        _editView.backgroundColor = [UIColor whiteColor];
        _editView.layer.shadowOpacity = 0.5;
        _editView.layer.shadowRadius = 20;
        _editView.layer.shadowOffset = CGSizeMake(10, 10);
        _editView.layer.shadowColor = [[UIColor blackColor] CGColor];
        _editView.layer.cornerRadius = cornerRadius;
        _editView.center = CGPointMake(_backgroundView.center.x,_backgroundView.center.y - 150);

        [self addSubview:_editView];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, _editView.frame.size.width, _editView.frame.size.width);
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.3f] CGColor],
        (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
        (id)[[UIColor clearColor] CGColor],
        (id)[[UIColor colorWithWhite:0.0f alpha:0.3f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f,@0.8f,@1.00f];
        _gradientLayer.cornerRadius = cornerRadius;
        [_editView.layer addSublayer:_gradientLayer];
    }
    return self;
}


-(void)handleTap:(UITapGestureRecognizer *)sender {
    
    
    /*CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    myAnimation.toValue = [NSNumber numberWithFloat:0.0];
    myAnimation.duration = 0.25;
    myAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    myAnimation.
    [self.layer addAnimation:myAnimation forKey:@"myAnimation"];
    */
    [UIView animateWithDuration:0.25 animations:^{
        [self.layer setOpacity:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)layoutSubviews {
    _editView.center = CGPointMake(_backgroundView.center.x,_backgroundView.center.y - 150);
    _gradientLayer.frame = _editView.bounds;
}



@end
