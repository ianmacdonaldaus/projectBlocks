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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 200, 30)];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.textColor = [UIColor blackColor];
    nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTextField];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(72, 120, 32, 32)];
    [deleteButton setImage:[UIImage imageNamed:@"delete_32x32b.png"] forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"delete_32x32.png"] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
  
 }

-(void)delete:(id)sender {
    [managedObjectContext deleteObject:project];
 }

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    nameTextField.text = project.name;    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![nameTextField.text isEqualToString:project.name]) {
        [self.project setValue:nameTextField.text forKey:@"name"];
        [self.managedObjectContext save:nil];
    }
}

@end
