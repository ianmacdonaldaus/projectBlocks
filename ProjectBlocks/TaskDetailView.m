//
//  TaskDetailView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 12/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TaskDetailView.h"
#import "DismissingView.h"
#import <QuartzCore/QuartzCore.h>

@interface TaskDetailView ()

@end

@implementation TaskDetailView {
    CGRect _viewBounds;
    CAGradientLayer *_gradientLayer;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize task = _task;
@synthesize taskDetailTextView = _taskDetailTextView;
@synthesize taskTitleTextField = _taskTitleTextField;
@synthesize detailViewColor = _detailViewColor;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(70, 15, 330, 40)];
    view1.layer.cornerRadius = 5;
    view1.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:view1 atIndex:0];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(70, 75, 330, 120)];
    view2.layer.cornerRadius = 5;
    view2.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:view2 atIndex:0];
    
    self.view.backgroundColor = _detailViewColor;
    
    self.view.layer.cornerRadius = 12;
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.view.frame;
    _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
    (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
    (id)[[UIColor clearColor] CGColor],
    (id)[[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor]];
    _gradientLayer.locations = @[@0.00f, @0.04f,@0.8f,@1.00f];
    [self.view.layer addSublayer:_gradientLayer];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    CGRect frame = self.view.superview.bounds;
//    frame.origin.x += 400;
//    frame.origin.y -= 20;
//    frame.size.width = 420;
//    frame.size.height = 300;
//    self.view.superview.bounds = frame;
        self.view.superview.bounds = CGRectMake(0, 0, 420, 300);

   // UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //DismissingView *dismiss = [[DismissingView alloc] initWithFrame:window.frame target:self selector:@selector(dismissView:)];
//    [dismiss addToWindow:window];

}

-(void)viewDidAppear:(BOOL)animated {
    _taskDetailTextView.text = _task.titleDetail;
    _taskTitleTextField.text = _task.title;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissView:(id)sender {
    [self.managedObjectContext save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _task.title = _taskTitleTextField.text;
    _task.titleDetail = _taskDetailTextView.text;
    [self.managedObjectContext save:nil];
}

@end
