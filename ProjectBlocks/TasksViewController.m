//
//  CVViewController.m
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "TasksViewController.h"
#import "TasksViewLayout.h"
#import "TaskViewCell.h"
#import "Task.h"
#import "Section.h"

@interface TasksViewController ()

@end

@implementation TasksViewController {
//    NSMutableArray *arrayOfRows;
    NSMutableArray *arrayOfSections;
}

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize project = _project;


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
    
    [self.collectionView registerClass:[TaskViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    [self.collectionView reloadData];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.maximumZoomScale = 1.0f;
    self.collectionView.zoomScale = 0.5f;
    
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.numberOfTapsRequired = 2.0f;
    [self.collectionView addGestureRecognizer:tapGestureRecognizer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 20, 80, 40);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    if ([_project.section count] == 0) {
        Section* section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:_managedObjectContext];
        section.project = _project;
        [self.managedObjectContext save:nil];
    }
    NSLog(@"%i", [_project.section count]);
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    //[self addDefaultSection];
    NSLog(@"number of sections: %i",[[_fetchedResultsController sections] count]);
}

-(void)loadStartupData {
    arrayOfSections = [NSMutableArray array];
    for (int s=0; s<3; s++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            float randomWidth = 10.0f + 100.0f * (float)random()/RAND_MAX;
            NSNumber* number = [NSNumber numberWithFloat:randomWidth];
            [tempArray addObject:number];
        }
        [arrayOfSections addObject:tempArray];
    }
}

-(void)handleBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout widthForItemAtIndexPath:(NSIndexPath*)indexPath {

    /*NSNumber* number = (NSNumber*)[[arrayOfSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return [number floatValue];
    */
    return 100.0f;
}


#pragma mark -
#pragma mark Gesture Recognizers

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (tappedCellPath!=nil)
        {
            [[arrayOfSections objectAtIndex:tappedCellPath.section] removeObjectAtIndex:tappedCellPath.row];
           
            NSLog(@"%i", [self.collectionView numberOfItemsInSection:tappedCellPath.section]);
            NSLog(@"%i",[[arrayOfSections objectAtIndex:tappedCellPath.section] count]);

            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedCellPath]];
            } completion:nil];
        }
        else
        {
            [self addTask];
/*            float randomWidth = 10.0f + 100.0f * (float)random()/RAND_MAX;
            NSNumber* number = [NSNumber numberWithFloat:randomWidth];
            [[arrayOfSections objectAtIndex:0] addObject:number];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:([self.collectionView numberOfItemsInSection:0]) inSection:0]]];
            } completion:nil];
 */
        }
    }
}

-(void)addTask {
    Task* task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:_managedObjectContext];
    task.section = _project.section.anyObject;
    
    //Set Duration
    NSDate* result;
    NSDateComponents *comps =[[NSDateComponents alloc] init];
    [comps setMinute:0];
    [comps setHour:1];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    result = [gregorian dateFromComponents:comps];
    task.duration = result;

    //Set title
    task.title = @"New Task";
    [_managedObjectContext save:nil];
}

#pragma mark -
#pragma mark Miscellaneous

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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", _project];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"Section" cacheName:@"Tasks"];
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

-(void)addDefaultSection {
    NSLog(@"number of sections: %i",[[_fetchedResultsController sections] count]);
    if (!([[_fetchedResultsController sections] count] > 0)) {
        Section* section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:_managedObjectContext];
        section.project = _project;
        [self.managedObjectContext save:nil];
    }
    NSLog(@"number of sections: %i",[[_fetchedResultsController fetchedObjects] count]);
    
}

@end
