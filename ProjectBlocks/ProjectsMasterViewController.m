//
//  ProjectsMasterViewController.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 11/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectsMasterViewController.h"
#import "ProjectPopOverViewController.h"
#import "Project.h"
#import "ProjectsViewLayout.h"
#import "TasksViewController.h"
#import "ProjectViewCell.h"
#import "BackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectsMasterViewController ()

@end

@implementation ProjectsMasterViewController {
    ProjectPopOverViewController* popOver;
}

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailPopOver = _detailPopOver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[ProjectViewCell class] forCellWithReuseIdentifier:@"ProjectCell"];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //Backgrounds
    
    BackgroundView *backgroundView = [[BackgroundView alloc] initWithFrame:self.view.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:backgroundView atIndex:0];
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // Buttons
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 32, 32)];
    [addButton setImage:[UIImage imageNamed:@"add_32x32b.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"add_32x32.png"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addProject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
        
    // Editing Popover
    popOver = [[ProjectPopOverViewController alloc] init];
    popOver.managedObjectContext = self.managedObjectContext;
    _detailPopOver = [[UIPopoverController alloc] initWithContentViewController:popOver];
    _detailPopOver.popoverContentSize = CGSizeMake(240., 240.);
	_detailPopOver.delegate = self;
	
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
//    [self loadStartupData];

}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}

-(void)viewWillLayoutSubviews {
}

-(void) popoverDone:(id)sender {
    NSLog(@"popover done");
}


- (void)popOver:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    CGPoint newPoint = [button convertPoint:button.bounds.origin toView:self.view];
    popOver.project = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    [_detailPopOver presentPopoverFromRect:CGRectMake(newPoint.x + 20, newPoint.y + button.frame.size.height / 2, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

-(void)addProject {
    Project* project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_managedObjectContext];
    project.name = @"New Project";
    [_managedObjectContext save:nil];
    [self.collectionView reloadData];
}

- (void)configureCell:(ProjectViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Project *project = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.projectTitle.text = project.name;
    

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    containerView.layer.cornerRadius = 15;
    containerView.clipsToBounds = YES;
//    [cell addSubview:containerView];
    
    UIView *colourView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, cell.frame.size.width, cell.frame.size.height - 50)];
    colourView.backgroundColor = [UIColor colorWithHue:(0.08 * indexPath.row) saturation:0.8 brightness:0.9 alpha:1.0];
    
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowRadius = 10;
    cell.layer.shadowOffset = CGSizeMake(7, 7);
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    //[containerView addSubview:colourView];
    
    cell.clipsToBounds = NO;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     
    ProjectViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView*)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender
{
    return([NSStringFromSelector(action) isEqualToString:@"cut:"]);
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"cut:"])
    {
        
        [_managedObjectContext deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"taskViewSegue"] ) {
        TasksViewController *tasksViewController = (TasksViewController *)[segue destinationViewController];
        tasksViewController.managedObjectContext = self.managedObjectContext;
        NSIndexPath *index = [self.collectionView indexPathForCell:sender];
        tasksViewController.project = (Project *)[_fetchedResultsController objectAtIndexPath:index];
        
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   [self performSegueWithIdentifier:@"taskViewSegue" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
}


@end
