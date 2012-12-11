//
//  ProjectPopOverViewController.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 02/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectPopOverViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) Project* project;
@property (nonatomic, strong) IBOutlet UITextField* nameTextField;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
