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

@implementation TaskEditModalView {
    UITextField *taskTitleTextField;
    UITextView *taskDetailsTextView;
    UILabel *taskDurationLabel;
    
    RotationControlView *rotationControlView;
    OneFingerRotationGestureRecognizer *oneFingerRotationGestureRecognizer;
    @private CGFloat imageAngle;
    
}

@synthesize task = _task;
@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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
//    [taskTitleTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
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
    //[self.taskTitleDetailsTextView addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [self.editView addSubview:taskDetailsTextView];
    
    taskDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 255, self.editView.frame.size.width - 85, 30)];
    taskDurationLabel.backgroundColor = [UIColor clearColor];
    taskDurationLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:20];
    taskDurationLabel.textColor = textColor;
    
    taskDurationLabel.text = [self.task getTaskDurationAsString];
    taskDurationLabel.textAlignment = NSTextAlignmentRight;
    
    [self.editView addSubview:taskDurationLabel];

}

-(void)createRotationScreen {
    float circleRadius = 200.0f;
    // Create the container view - this will intercept all other
    //_rotationView = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    //_rotationView.backgroundColor = [UIColor clearColor];
    
    //CREATE THE CIRCLEVIEW - THIS WILL BE ROTATED WITH THE GESTURE
    rotationControlView = [[RotationControlView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - circleRadius / 2, 3 * self.bounds.size.height / 4 - circleRadius / 2, circleRadius, circleRadius)];
    rotationControlView.layer.cornerRadius = circleRadius / 2;
    rotationControlView.backgroundColor = [UIColor clearColor];
    rotationControlView.opaque = YES;
    rotationControlView.hidden = YES;
    
    //ADD THE NEW VIEWS
    //[rotationControlView addSubview:_circleView];
    [self addSubview:rotationControlView];
    
    //IMPLEMENT THE GESTURE RECOGNIZER
    CGPoint midPoint = CGPointMake(rotationControlView.bounds.size.width/2, rotationControlView.bounds.size.height / 2);
    CGFloat outRadius = rotationControlView.frame.size.width / 2;
    
    oneFingerRotationGestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint:midPoint innerRadius:outRadius / 4 outerRadius:outRadius * 2 target:self];
    [rotationControlView addGestureRecognizer:oneFingerRotationGestureRecognizer];
    
    //IMPLEMENT THE DISMISS ROTATION SCREEN GESTURE RECOGNIZER
//    UITapGestureRecognizer *oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRotationScreen:)];
 //   oneTapGestureRecognizer.numberOfTapsRequired = 1;
 //   [_rotationView addGestureRecognizer:oneTapGestureRecognizer];
    
}

#pragma mark - CircularGestureRecognizerDelegate protocol

- (void) rotation: (CGFloat) angle
{
    // calculate rotation angle
    float newDurationLength = [self.task.durationMinutes floatValue] * (1 + angle/360);
    //self.disableCollectionViewAnimations = YES;
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.task.durationMinutes = [NSNumber numberWithFloat:newDurationLength];
    // [self.collectionView reloadData];
    [CATransaction commit];
    
    //_rotationText.text = [NSString stringWithFormat:@"%f",_selectedCell.bounds.size.width];
    
    
    imageAngle += angle;
    if (imageAngle > 360)
        imageAngle -= 360;
    else if (imageAngle < -360)
        imageAngle += 360;
    
    // rotate image and update text field
    rotationControlView.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
}

- (void) finalAngle: (CGFloat) angle
{
    // circular gesture ended, update text field
    
}

#pragma mark -
#pragma mark Text UIControl methods

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


@end
