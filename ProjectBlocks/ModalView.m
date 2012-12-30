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
        
        
        //Background View
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.layer.opacity = 0.65;
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        
        
        //Edit View Box
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

        // Gesture recognizers
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];

    }
    return self;
}


-(void)handleTap:(UITapGestureRecognizer *)sender {
    CGPoint locationOfTouch = [sender locationInView:sender.view];
    UIView* subview = [sender.view hitTest:locationOfTouch withEvent:nil];
    
    if (subview == self.backgroundView) {
        NSLog(@"BackgroundView tapped");
        [UIView animateWithDuration:0.25 animations:^{
            [self.layer setOpacity:0.0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        return;
    }
    if (subview == self.editView) {
        [self endEditing:YES];
        return;
    }
    
}

#pragma mark -
#pragma mark Text Field Methods

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(void)hideKeyboard {
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark -
#pragma mark Reposition on rotation

-(void)layoutSubviews {
    _editView.center = CGPointMake(_backgroundView.center.x,_backgroundView.center.y - 150);
    _gradientLayer.frame = _editView.bounds;
}



@end
