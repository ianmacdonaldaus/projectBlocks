//
//  TaskEditModalView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 19/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TaskEditModalView.h"
#import "CoreDataHelper.h"
#import "RotationControlView.h"
#import "OneFingerRotationGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

static float cornerRadius = 15;

@implementation TaskEditModalView {
    
    UITextField *taskTitleTextField;
    UITextView *taskDetailsTextView;
    UILabel *taskDurationLabel;
    
    RotationControlView *rotationControlView;
    OneFingerRotationGestureRecognizer *oneFingerRotationGestureRecognizer;
    @private CGFloat imageAngle;
    UILabel *rotationLabel;    
}

@synthesize backgroundView = _backgroundView;
@synthesize editView = _editView;
@synthesize gradientLayer = _gradientLayer;

@synthesize task = _task;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize showRotationControl = _showRotationControl;

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
     
        [self createRotationView];

    }
    return self;
}


-(void)didMoveToWindow {
    
    // Need to include a test for background colour and set text colour
    UIColor *textColor = [UIColor whiteColor];
    
    // Add Title textfield
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(60, 20, self.editView.frame.size.width - 80, 45)];
    view1.layer.cornerRadius = 10;
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.opacity = 0.5;
    view1.layer.shadowOpacity = 0.2;
    [self.editView insertSubview:view1 atIndex:0];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(60, 90, self.editView.frame.size.width - 80, 140)];
    view2.layer.cornerRadius = 10;
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.opacity = 0.5;
    view2.layer.shadowOpacity = 0.2;
    [self.editView insertSubview:view2 atIndex:0];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 55, 30)];
    label1.text = @"Title";
    label1.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:16];
    label1.textAlignment = NSTextAlignmentRight;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = textColor;
    label1.layer.opacity = 0.5;
    [self.editView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 98, 55, 30)];
    label2.text = @"Details";
    label2.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:16];
    label2.textAlignment = NSTextAlignmentRight;
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = textColor;
    label2.layer.opacity = 0.5;
    [self.editView addSubview:label2];
    
    taskTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 27, self.editView.frame.size.width - 85, 30)];
    taskTitleTextField.text = self.task.title;
    taskTitleTextField.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:20];
    taskTitleTextField.clearButtonMode = UITextFieldViewModeAlways;
    taskTitleTextField.textColor = textColor;
    taskTitleTextField.backgroundColor = [UIColor clearColor];
    taskTitleTextField.delegate = self;
    [self.editView addSubview:taskTitleTextField];
    
    
    // Add TitleDetail textfield
    
    taskDetailsTextView = [[UITextView alloc] initWithFrame:CGRectMake(60, 92, self.editView.frame.size.width - 85, 120)];
    taskDetailsTextView.text = self.task.titleDetail;
    taskDetailsTextView.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:20];
    taskDetailsTextView.textColor = textColor;
    taskDetailsTextView.backgroundColor = [UIColor clearColor];
    taskDetailsTextView.showsVerticalScrollIndicator = YES;
    taskDetailsTextView.delegate = self;
    [self.editView addSubview:taskDetailsTextView];
    
    taskDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.editView.frame.size.width * 2 / 3, 255, self.editView.frame.size.width / 4, 45)];
    taskDurationLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    taskDurationLabel.layer.cornerRadius = 10;
    taskDurationLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:20];
    taskDurationLabel.textColor = textColor;
    
    taskDurationLabel.text = [self.task getTaskDurationAsString];
    taskDurationLabel.textAlignment = NSTextAlignmentCenter;
    taskDurationLabel.opaque = YES;
    taskDurationLabel.userInteractionEnabled = YES;
    

    [self.editView addSubview:taskDurationLabel];
        
    if (self.showRotationControl) {
        self.editView.hidden = YES;
        self.backgroundView.layer.opacity = 0.1;
        [self showRotationView];
    } else {
        self.editView.hidden = NO;
        rotationControlView.hidden = YES;
    }
}

#pragma mark -
#pragma mark Handle Gestures

-(void)handleTap:(UITapGestureRecognizer *)sender {
    CGPoint locationOfTouch = [sender locationInView:sender.view];
    UIView* subview = [sender.view hitTest:locationOfTouch withEvent:nil];
    
    if (subview == self.backgroundView) {
        [UIView animateWithDuration:0.25 animations:^{
            rotationControlView.layer.transform = CATransform3DMakeScale(0, 0, 0);
            rotationLabel.layer.transform = CATransform3DMakeScale(0, 0, 0);
            [self.layer setOpacity:0.0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        return;
    }
    if (subview == taskDurationLabel) {
        [self endEditing:YES];
        [self showRotationView];
        return;
    }
    if (subview == self.editView) {
        [self endEditing:YES];
        [self hideRotationView];
        return;
    }
}

-(void)showRotationView {
    rotationControlView.hidden = NO;
    rotationLabel.hidden = NO;
    [rotationControlView setNeedsDisplay];
    [rotationLabel setNeedsDisplay];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.fromValue = [NSNumber numberWithInt:0.0];
    [rotationControlView.layer addAnimation:animation forKey:nil];
    
}

-(void)hideRotationView {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.toValue = [NSNumber numberWithInt:0.0];
    [rotationControlView.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        rotationControlView.layer.transform = CATransform3DMakeScale(0, 0, 0);
        rotationLabel.layer.transform = CATransform3DMakeScale(0, 0, 0);
    } completion:^(BOOL finished) {
        rotationControlView.hidden = YES;
        rotationLabel.hidden = YES;
    }];

}

#pragma mark -
#pragma mark Rotation View

-(void)createRotationView {
    
    float circleRadius = 200.0f;
    
    //Create the RotationControlView
    CGRect rotationControlViewFrame = CGRectMake(self.bounds.size.width / 2 - circleRadius / 2, 3 * self.bounds.size.height / 4 - circleRadius / 2, circleRadius, circleRadius);
    rotationControlView = [[RotationControlView alloc] initWithFrame:rotationControlViewFrame];
    rotationControlView.layer.cornerRadius = circleRadius / 2;
    rotationControlView.backgroundColor = [UIColor clearColor];
    rotationControlView.opaque = YES;
    rotationControlView.hidden = YES;
    [self addSubview:rotationControlView];
    
    rotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    rotationLabel.center = rotationControlView.center;
    rotationLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:24];
    rotationLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    rotationLabel.backgroundColor = [UIColor clearColor];
    rotationLabel.textAlignment = NSTextAlignmentCenter;
    rotationLabel.text = [self.task getTaskDurationAsString];
    rotationLabel.hidden = YES;
    [self addSubview:rotationLabel];
    
    //Add gesture recognizer
    CGPoint midPoint = CGPointMake(rotationControlView.bounds.size.width/2, rotationControlView.bounds.size.height / 2);
    CGFloat outRadius = rotationControlView.frame.size.width / 2;
    
    oneFingerRotationGestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint:midPoint innerRadius:outRadius / 4 outerRadius:outRadius * 2 target:self];
    [rotationControlView addGestureRecognizer:oneFingerRotationGestureRecognizer];
    
}

#pragma mark - CircularGestureRecognizerDelegate protocol

- (void) rotation: (CGFloat) angle
{
    // calculate rotation angle
    float newDurationLength = [self.task.durationMinutes floatValue] * (1 + angle/360);
    newDurationLength = MAX(newDurationLength, 1.0);
    
    
    rotationLabel.text = [self.task getTaskDurationAsString];
    taskDurationLabel.text = rotationLabel.text;
    
    imageAngle += angle;
    if (imageAngle > 360)
        imageAngle -= 360;
    else if (imageAngle < -360)
        imageAngle += 360;
    
    // rotate image and update text field
   
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.task.durationMinutes = [NSNumber numberWithFloat:newDurationLength];
        rotationControlView.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
    [CATransaction commit];
}

- (void) finalAngle: (CGFloat) angle
{
    // circular gesture ended, update text field
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.task.title = taskTitleTextField.text;
    self.task.titleDetail = taskDetailsTextView.text;
    [self.managedObjectContext save:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    self.task.title = taskTitleTextField.text;
    self.task.titleDetail = taskDetailsTextView.text;
    [self.managedObjectContext save:nil];
}


#pragma mark -
#pragma mark Reposition on rotation

-(void)layoutSubviews {
    _editView.center = CGPointMake(_backgroundView.center.x,_backgroundView.center.y - 150);
    _gradientLayer.frame = _editView.bounds;
    rotationControlView.center = CGPointMake(_backgroundView.center.x, _backgroundView.center.y + 150);
    rotationLabel.center = rotationControlView.center;
}


@end
