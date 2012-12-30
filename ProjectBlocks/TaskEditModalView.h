//
//  TaskEditModalView.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 19/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalView.h"
#import "Task.h"

@interface TaskEditModalView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) Task *task;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *editView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (nonatomic) BOOL showRotationControl;

@end
