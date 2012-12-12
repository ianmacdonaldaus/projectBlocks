//
//  ProjectsViewController.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 01/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

// To include paging (so it scrolls to an item) I need to subclass UICollectionViewFlowLayout and add
// targetContentOffsetForProposedContentOffset:withScrollingVelocity:

#import "ProjectsViewController.h"
#import "ProjectPopOverViewController.h"
#import "ProjectViewCell.h"
#import "Project.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController {
    ProjectPopOverViewController* popOver;
}

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize detailPopOver;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;


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
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newButton.frame = CGRectMake(100 , 20, 70 , 30);
    [newButton setTitle:@"Add new" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(addProject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
    
    popOver = [[ProjectPopOverViewController alloc] init];
    popOver.managedObjectContext = self.managedObjectContext;
    detailPopOver = [[UIPopoverController alloc] initWithContentViewController:popOver];
    detailPopOver.popoverContentSize = CGSizeMake(240., 320.);
	detailPopOver.delegate = self;
	
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    [self loadStartupData];

}

-(void)addProject {
    Project* project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    project.name = @"Next Task";
    [managedObjectContext save:nil];
    //[self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [fetchedResultsController sections].count;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Project *project = [fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 40)];
    label.text = project.name;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"Futura-Medium" size:20];
    [cell addSubview:label];
    
    cell.layer.cornerRadius = 10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [button setCenter:CGPointMake(280, 25)];
    [button showsTouchWhenHighlighted];
    [button setTag:indexPath.row];
    [button addTarget:self action:@selector(popOver:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    containerView.layer.cornerRadius = 10;
    containerView.clipsToBounds = YES;
    [cell addSubview:containerView];
    
    UIView *colourView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 300, 250)];
    colourView.backgroundColor = [UIColor colorWithHue:(0.07 * indexPath.row) saturation:0.8 brightness:0.9 alpha:1.0];
    
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowRadius = 10;
    cell.layer.shadowOffset = CGSizeMake(7, 7);
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [containerView addSubview:colourView];
    
    cell.clipsToBounds = NO;
    [cell addSubview:button];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectCell";
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark Dummy data



- (IBAction)popOver:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    CGPoint newPoint = [button convertPoint:button.bounds.origin toView:self.view];
    // Project *selectedProject = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    popOver.project = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    [detailPopOver presentPopoverFromRect:CGRectMake(newPoint.x + 20, newPoint.y + button.frame.size.height / 2, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
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
        
        [managedObjectContext deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
        
        //make changes to the managedObjectContext - the fetchedResultsController is watching for changes to the managedObjectContext and will update the collectionview accodingly...
    }
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController) return fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Project"
                inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"name"
                                ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext
                                          sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    [self setFetchedResultsController:aFetchedResultsController];
    
    return fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UICollectionView *collectionView = self.collectionView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
            
        case NSFetchedResultsChangeDelete:
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath] ];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[collectionView cellForItemAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [collectionView deleteItemsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath]];
            [collectionView insertItemsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath]];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] ];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
    }
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

-(void)loadStartupData {
    if ([[fetchedResultsController fetchedObjects] count] > 0) {
        return;
    }
    Project* project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    project.name = @"Christmas Roast";
    
    project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    project.name = @"Home renovations";
    
    project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    project.name = @"Plan the 2013 holiday";
    
    [managedObjectContext save:nil];
}


    @end
