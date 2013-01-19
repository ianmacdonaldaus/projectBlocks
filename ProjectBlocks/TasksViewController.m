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
#import "TasksViewSectionSupplementaryCell.h"
#import "TaskEditModalView.h"
#import "Task.h"
#import "Colors.h"
#import "RotationControlView.h"
#import "OneFingerRotationGestureRecognizer.h"
#import "BackgroundView.h"
#import "CoreDataHelper.h"
#import <QuartzCore/QuartzCore.h>

#define MINSCALE 1
#define MAXSCALE 10

@interface TasksViewController ()

@end

@implementation TasksViewController {
    float durationScale;
    float startingDurationScale;
    float startingPinchScale;
    
    UIView *_rotationView;
    RotationControlView *_circleView;
    @private CGFloat imageAngle;
    @private OneFingerRotationGestureRecognizer *oneFingerGestureRecognizer;
    
    Task* selectedTask;
    NSArray *sortedColors;


}

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize project = _project;
@synthesize colorPalette = _colorPalette;


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
    
    durationScale = 3.0f;
    
    [self.collectionView registerClass:[TaskViewCell class] forCellWithReuseIdentifier:@"TaskCell"];
    [self.collectionView registerClass:[TasksViewSectionSupplementaryCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionCell"];
    [self.collectionView reloadData];
    self.collectionView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.pagingEnabled = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    // Create the background view
    BackgroundView *backgroundView = [[BackgroundView alloc] initWithFrame:self.view.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:backgroundView atIndex:0];

    // Create the topBar
    UIView* topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(self.view.bounds.size.width,self.view.bounds.size.height), 50)];
    topBar.backgroundColor = [UIColor whiteColor];
    topBar.layer.shadowOpacity = 0.2;
    topBar.layer.shadowRadius = 3;
    topBar.layer.shadowOffset = CGSizeMake(0, 2);
    topBar.layer.shouldRasterize = YES;
    topBar.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:topBar];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 10, 80, 30);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleBackButton) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 400, 40)];
    label.text = self.project.name;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:24];
    [topBar addSubview:label];

    // Add gesture recognizers

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
        
    UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.collectionView addGestureRecognizer:pinchGestureRecognizer];
    
    // Instantiate the fetchedresultscontroller
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    sortedColors = [[self.colorPalette.colors allObjects] sortedArrayUsingDescriptors:sortDescriptors];

    for (Task *task in [self.fetchedResultsController fetchedObjects]) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:task];
        if (task.index != [NSNumber numberWithInt:indexPath.row]) {
            task.index = [NSNumber numberWithInt:indexPath.row];
        }

    }
}

-(void)handleBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark Collection View Methods

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    Task* task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Add Task Title Label
    cell.taskLabel.text = task.title;
    
    // Add duration Label
    //cell.durationLabel.text = [task getTaskDurationAsString];
    NSString *debugString = [NSString stringWithFormat:@"%@ %@ %@",[task.sequential boolValue] ? @"YES" : @"NO" , [task.section stringValue], [task.index stringValue] ];
    cell.durationLabel.text = debugString;
    
    
    //Add color Palette
    float colorIndex = indexPath.section;
    if (colorIndex > 4) {
        colorIndex =  ( (colorIndex) / 5 - floorf((colorIndex)/5) ) * 5;
    }
    Colors *colors = [sortedColors objectAtIndex:colorIndex];
    UIColor *color = colors.color;
    float hue;
    float saturation;
    float brightness;
    float alpha;
    BOOL lightness = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (saturation < 0.5 && brightness > 0.7) {
        cell.taskLabel.textColor = [UIColor blackColor];
        cell.durationLabel.textColor = [UIColor blackColor];
    } else {
        cell.taskLabel.textColor = [UIColor whiteColor];
        cell.durationLabel.textColor = [UIColor whiteColor];
    }
    BOOL yellow = (hue > 0.13) && (hue < 0.2083);
    BOOL green = (hue > 0.40) && (hue < 0.5222);
    if (brightness > 0.65) {
        if (yellow || green) {
        cell.taskLabel.textColor = [UIColor blackColor];
        cell.durationLabel.textColor = [UIColor blackColor];
        }
    }
   
    float countOfItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    float steps = MAX(countOfItems, 10);
    float differenceToLastItem = countOfItems - (indexPath.row + 1);
    float proportionToLastItem = differenceToLastItem / countOfItems;
    brightness = brightness - (0.4 * differenceToLastItem/steps);
    cell.contentView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
        
    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
   
    TasksViewSectionSupplementaryCell *sectionView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionCell" forIndexPath:indexPath];
    
    float colorIndex = indexPath.section;
    if (colorIndex > 4) {
        colorIndex =  ( (colorIndex) / 5 - floorf((colorIndex)/5) ) * 5;
    }
    Colors *colors = [sortedColors objectAtIndex:colorIndex];
    UIColor *color = colors.color;

    //sectionView.layer.backgroundColor = [color CGColor];
    sectionView.contentView.layer.backgroundColor = [color CGColor];
//    sectionView.layer.opacity = 0.25;
    return sectionView;
}

- (CGFloat)widthForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSLog(@"width for indexPath: %@", indexPath);
    Task* task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    float minutes = [task.durationMinutes floatValue];
    float width = minutes * durationScale;
    return width;
}

-(BOOL) sequentialForItemAtIndexPath:(NSIndexPath*)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [task sequentialForItemAtIndexPath];
}

-(id)objectInProjectAtIndex:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return task;
}


#pragma mark -
#pragma mark Gesture Recognizers

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialTapPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialTapPoint];
        selectedTask = [self.fetchedResultsController objectAtIndexPath:tappedCellPath];
        if (selectedTask) {
            [self showTaskEditModalView:tappedCellPath rotation:NO];
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
                if (tappedCellPath!=nil)
                {
                    selectedTask = [self.fetchedResultsController objectAtIndexPath:tappedCellPath];
                    [self showTaskEditModalView:tappedCellPath rotation:YES];
                } else {
                    [self addTask];
                }
    }
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        startingDurationScale = durationScale;
        startingPinchScale = [sender scale];
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        durationScale = startingDurationScale * ([sender scale] / startingPinchScale);
        
        durationScale = durationScale > MAXSCALE ? MAXSCALE : durationScale;
        durationScale = durationScale < MINSCALE ? MINSCALE : durationScale;

        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            [self.collectionView reloadData];
        [CATransaction commit];
    }
}

- (void)showTaskEditModalView:(NSIndexPath*)indexPath rotation:(BOOL)rotation {
    TaskEditModalView *modalView = [[TaskEditModalView alloc] initWithFrame:self.view.bounds];
    modalView.managedObjectContext  = self.managedObjectContext;
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    modalView.showRotationControl = rotation;
    modalView.task = task;
    [modalView.layer setOpacity:0.0];
    [self.view addSubview:modalView];
    
    modalView.editView.backgroundColor = [self.collectionView cellForItemAtIndexPath:indexPath].contentView.backgroundColor;

    [UIView animateWithDuration:0.25 animations:^{
        [modalView.layer setOpacity:1.0];
    } completion:^(BOOL finished) { nil; }];
    
}

-(void)addTask {
    Task* task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task.project = _project;
    
    //Set Default Duration
    float result = 10.0f + 80.0f * (float)random()/RAND_MAX;
    task.durationMinutes = [NSNumber numberWithFloat:result];
     
    //Set sequential boolean
    float randomNumber = (float)random()/RAND_MAX;
    task.sequential = randomNumber > 0.7 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
    float sectionIndex = floorf(randomNumber * 5);
    task.section = [NSNumber numberWithFloat:sectionIndex];
    
    //Set title
    task.title = _project.name;
    
    //Set index
    task.index = [NSNumber numberWithInteger:[[self.fetchedResultsController fetchedObjects] count]];

    // Need to change the index to be the number of object within the current section...
    
//    [self.managedObjectContext save:nil];
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
    NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSSortDescriptor *sortDescriptorRow = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorSection, sortDescriptorRow];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project == %@", _project];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"section" cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editTask"] ) {
        TaskDetailView *taskDetailView = (TaskDetailView *)[segue destinationViewController];
        TaskViewCell *cell = (TaskViewCell *)sender;
        taskDetailView.detailViewColor = cell.contentView.backgroundColor;
        taskDetailView.managedObjectContext = _managedObjectContext;
        NSIndexPath *index = [self.collectionView indexPathForCell:sender];
        taskDetailView.task = (Task *)[self.fetchedResultsController objectAtIndexPath:index];
        
    }
    
}*/

/*-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showTaskEditModalView:indexPath rotation:NO];
}
*/

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout item:(Task *)taskToBeMoved willMoveToIndexPath:(NSIndexPath *)theToIndexPath {
 
    NSMutableArray *objectsToIncreaseIndex = [NSMutableArray array];
    NSMutableArray *objectsToDecreaseIndex = [NSMutableArray array];
    NSIndexPath *theFromIndexPath = [self.fetchedResultsController indexPathForObject:taskToBeMoved];
    
    int fromSection = theFromIndexPath.section;
    int toSection = theToIndexPath.section;
    
    if (theFromIndexPath.section == theToIndexPath.section) {
        int movingUpwards = 1 ? theFromIndexPath.row <  theToIndexPath.row : 0;
        
        for (int i = 0; i<[self.collectionView numberOfItemsInSection:fromSection]; i++) {
            Task *task = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:i inSection:fromSection]];
            if (movingUpwards == 1) {
                
                if ([task.index integerValue] > theFromIndexPath.row && [task.index integerValue] <= theToIndexPath.row) {
                    [objectsToDecreaseIndex addObject:task];
                }

            } else {
                
                if ([task.index integerValue] < theFromIndexPath.row && [task.index integerValue] >= theToIndexPath.row) {
                    [objectsToIncreaseIndex addObject:task];
                }

            }
        }
    } else {

        for (int i = 0; i<[self.collectionView numberOfItemsInSection:fromSection]; i++) {
            Task *task = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:i inSection:fromSection]];
            if ([task.index integerValue] > theFromIndexPath.row) {
                [objectsToDecreaseIndex addObject:task];
            }
        }
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:toSection]; i++) {
            Task *task = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:i inSection:toSection]];
            if ([task.index integerValue] >= theToIndexPath.row) {
                [objectsToIncreaseIndex addObject:task];
            }
        }
    }

    for (Task *task in objectsToIncreaseIndex) {
        task.index = [NSNumber numberWithInt:([task.index integerValue] + 1)];
    }
    for (Task *task in objectsToDecreaseIndex) {
        task.index = [NSNumber numberWithInt:([task.index integerValue] - 1)];
    }
    
    taskToBeMoved.section = [NSNumber numberWithInt:theToIndexPath.section];
    taskToBeMoved.index = [NSNumber numberWithInt:theToIndexPath.row];

}

-(void)setTaskIndex:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    task.index = [NSNumber numberWithInt:indexPath.row];
}

@end
