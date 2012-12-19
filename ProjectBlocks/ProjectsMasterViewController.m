//
//  ProjectsMasterViewController.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 11/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectsMasterViewController.h"
#import "ProjectPopOverViewController.h"
#import "ProjectEditModalView.h"
#import "Project.h"
#import "ProjectsViewLayout.h"
#import "TasksViewController.h"
#import "ProjectViewCell.h"
#import "BackgroundView.h"
#import "CoreDataHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectsMasterViewController ()

@end

@implementation ProjectsMasterViewController {
    ProjectPopOverViewController* popOver;
}

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailPopOver = _detailPopOver;

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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(200, 200);
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    popOver = [[ProjectPopOverViewController alloc] initWithCollectionViewLayout:layout];
    popOver.managedObjectContext = self.managedObjectContext;
    
    
    //_detailPopOver = [[UIPopoverController alloc] initWithContentViewController:popOver];
    //_detailPopOver.popoverContentSize = CGSizeMake(240.0, 300.0);
	//_detailPopOver.delegate = self;
	
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

-(void) popoverDone:(id)sender {
    NSLog(@"popover done");
}

-(void)handleProjectInfoButton:(id)sender {
    UIButton *button = sender;
    CGPoint buttonCenter = [self.collectionView convertPoint:button.center fromView:[button superview]];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonCenter];
    [self showProjectEditModalView:indexPath];
    
}

- (void)showProjectEditModalView:(NSIndexPath*)indexPath {
    ProjectEditModalView *view = [[ProjectEditModalView alloc] initWithFrame:self.view.bounds];
    view.managedObjectContext  = self.managedObjectContext;
    view.project = [_fetchedResultsController objectAtIndexPath:indexPath];
    [view.layer setOpacity:0.0];
    
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.2 animations:^{
        [view.layer setOpacity:1.0];
    } completion:^(BOOL finished) {
        NSLog(@"bark");
    }];
    
}

-(void)addProject {
    
    Project* project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_managedObjectContext];
    project.name = @"New Project";
    int index = [[self.fetchedResultsController fetchedObjects] count];
 
    project.index = [NSNumber numberWithInt:index];
    if (index >= [CoreDataHelper countForEntity:@"ColorPalette" andContext:self.managedObjectContext]) {
        index = 0;
    }
    ColorPalette *colorPalette = [[CoreDataHelper getObjectsForEntity:@"ColorPalette" withSortKey:@"index" andSortAscending:YES andContext:self.managedObjectContext] objectAtIndex:index];
    project.colorPalette = colorPalette;
    
    [_managedObjectContext save:nil];
    [self.collectionView reloadData];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.collectionView numberOfItemsInSection:0]-1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self showProjectEditModalView:indexPath];
}

- (void)configureCell:(ProjectViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Project *project = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.projectTitle.text = project.name;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    cell.colorPalette = project.colorPalette;
    [CATransaction commit];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.frame = CGRectMake(cell.contentView.bounds.size.width - 30, 15, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:@selector(handleProjectInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
        
        Project *project = (Project *)[_fetchedResultsController objectAtIndexPath:index];

        tasksViewController.project = project;
        tasksViewController.colorPalette = project.colorPalette;
        
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   [self performSegueWithIdentifier:@"taskViewSegue" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
}


@end
