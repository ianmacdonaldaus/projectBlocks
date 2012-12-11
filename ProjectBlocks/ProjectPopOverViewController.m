//
//  ProjectPopOverViewController.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 02/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectPopOverViewController.h"

@interface ProjectPopOverViewController ()

@end

@implementation ProjectPopOverViewController

@synthesize nameTextField;
@synthesize project;
@synthesize managedObjectContext;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 200, 30)];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.textColor = [UIColor blackColor];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTextField];
    
 }

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    nameTextField.text = project.name;    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.project setValue:nameTextField.text forKey:@"name"];
    [self.managedObjectContext save:nil];
}

@end
