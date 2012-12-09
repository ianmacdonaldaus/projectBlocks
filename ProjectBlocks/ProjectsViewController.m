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
#import "Project.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

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
    //[self loadStartupData];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteButton.frame = CGRectMake(20 , 20, 70 , 30);
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteProject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];

    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newButton.frame = CGRectMake(100 , 20, 70 , 30);
    [newButton setTitle:@"Add new" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(addProject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteProject:)];
    [gestureRecognizer setNumberOfTapsRequired:2];
    [self.collectionView addGestureRecognizer:gestureRecognizer];
    
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)deleteProject:(UITapGestureRecognizer *)gesture {
    NSManagedObject *project = [[NSManagedObject alloc] init];
    project = [fetchedResultsController objectAtIndexPath:[self.collectionView indexPathForItemAtPoint:[gesture locationOfTouch:0 inView:self.collectionView]]];
    [managedObjectContext deleteObject:project];
}

-(void)addProject {
    Project* project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    project.name = @"Next Task";
    [managedObjectContext save:nil];
    [self.collectionView reloadData];
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
    return 1;
}


- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Project *project = [fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    
    label.text = project.name;
    label.textAlignment = NSTextAlignmentCenter;
    cell.layer.cornerRadius = 10;
    [cell addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [button setCenter:CGPointMake(260, 20)];
    [button setTag:indexPath.row];
    
    [button addTarget:self action:@selector(popOver:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:button];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark Dummy data

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

- (IBAction)popOver:(id)sender {
    ProjectPopOverViewController *controller = [[ProjectPopOverViewController alloc] init];
    
    
    UIButton *button = sender;
    int i = button.tag;
    
    
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:controller];
    [pop presentPopoverFromRect:controller.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    
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


    @end
