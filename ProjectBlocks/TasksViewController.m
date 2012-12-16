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
#import "TaskDetailView.h"
#import "Task.h"
#import "Section.h"
#import "RotationView.h"
#import "OneFingerRotationGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

#define MINSCALE 1
#define MAXSCALE 5

@interface TasksViewController ()

@end

@implementation TasksViewController {
    float durationScale;
    float startingDurationScale;
    float startingPinchScale;
    
    UIView *_rotationView;
    RotationView *_circleView;
    @private CGFloat imageAngle;
    @private OneFingerRotationGestureRecognizer *oneFingerGestureRecognizer;
    
    Task* selectedTask;

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
    
    durationScale = 3.0f;
    
    [self.collectionView registerClass:[TaskViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    [self.collectionView reloadData];
    self.collectionView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.maximumZoomScale = 1.0f;
    self.collectionView.zoomScale = 0.5f;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create the background view
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subtle-pattern-7.jpg"]];
    backgroundView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    backgroundView.layer.opacity = 0.8;
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

}

-(void)loadStartupData {
//    arrayOfSections = [NSMutableArray array];
    for (int s=0; s<3; s++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            float randomWidth = 10.0f + 100.0f * (float)random()/RAND_MAX;
            NSNumber* number = [NSNumber numberWithFloat:randomWidth];
            [tempArray addObject:number];
        }
  //      [arrayOfSections addObject:tempArray];
    }
}

-(void)handleBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    Task* task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Add Task Title Label
    cell.taskLabel.text = task.title;
    
    // Add duration Label
    float durationHours = floorf([task.durationMinutes floatValue] / 60);
    float durationMinutes = [task.durationMinutes floatValue] - (durationHours * 60);
    NSString *duration = [NSString stringWithFormat:@" %1.0fh %1.0fm",durationHours, durationMinutes];
    cell.durationLabel.text = duration;
    float steps = [[self.fetchedResultsController fetchedObjects] count];
    float hue = 0.1 - (0.1 / steps) * indexPath.row;
    float saturation = 1.0 + (0.1 / steps ) * indexPath.row;
    float brightness = 1.0 + (0.6 / steps ) * indexPath.row;
    cell.contentView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    
    return cell;
}

- (CGFloat)widthForItemAtIndexPath:(NSIndexPath*)indexPath {

    Task* task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    float minutes = [task.durationMinutes floatValue];
    float width = minutes * durationScale;
    return width;
}

- (BOOL)sequentialForItemAtIndexPath:(NSIndexPath*)indexPath {
    Task* task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BOOL sequential = [task.sequential boolValue];
    return sequential;
}

-(BOOL) returnABoolean {
    return YES;
}

#pragma mark -
#pragma mark Gesture Recognizers

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        selectedTask = [self.fetchedResultsController objectAtIndexPath:tappedCellPath];
        //selectedTask.title = @"I've been clicked";
        [self.collectionView reloadData];
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
                    [self createRotationScreen];

                } else {
                    [self addTask];
                }
    }
}

/* Code for delete object
 Task* task = [self.fetchedResultsController objectAtIndexPath:tappedCellPath];
 [self.managedObjectContext deleteObject:task];
*/

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

-(void)createRotationScreen {
    float circleRadius = 200.0f;
    //CREATE THE CONTAINER VIEW - THIS WILL INTERCEPT ALL OTHER GESTURES WHILE ROTATING
    _rotationView = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    _rotationView.backgroundColor = [UIColor clearColor];
    
    //CREATE THE CIRCLEVIEW - THIS WILL BE ROTATED WITH THE GESTURE
    _circleView = [[RotationView alloc] initWithFrame:CGRectMake(self.collectionView.bounds.size.width / 2 - circleRadius / 2, 3 * self.collectionView.bounds.size.height / 4 - circleRadius / 2, circleRadius, circleRadius)];
    _circleView.layer.cornerRadius = circleRadius / 2;
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.opaque = YES;
//    _circleView.layer.opacity = ;
    
    //ADD THE NEW VIEWS
    [_rotationView addSubview:_circleView];
    [self.view addSubview:_rotationView];
    
    //IMPLEMENT THE GESTURE RECOGNIZER
    CGPoint midPoint = CGPointMake(_circleView.bounds.size.width/2, _circleView.bounds.size.height / 2);
    CGFloat outRadius = _circleView.frame.size.width / 2;
    
    oneFingerGestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint:midPoint innerRadius:outRadius / 4 outerRadius:outRadius * 2 target:self];
    [_circleView addGestureRecognizer:oneFingerGestureRecognizer];
    
    //IMPLEMENT THE DISMISS ROTATION SCREEN GESTURE RECOGNIZER
    UITapGestureRecognizer *oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRotationScreen:)];
    oneTapGestureRecognizer.numberOfTapsRequired = 1;
    [_rotationView addGestureRecognizer:oneTapGestureRecognizer];
    
}

#pragma mark - CircularGestureRecognizerDelegate protocol

- (void) rotation: (CGFloat) angle
{
    // calculate rotation angle
    float newDurationLength = [selectedTask.durationMinutes floatValue] * (1 + angle/360);
    self.disableCollectionViewAnimations = YES;
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        selectedTask.durationMinutes = [NSNumber numberWithFloat:newDurationLength];
        [self.collectionView reloadData];
    [CATransaction commit];
    
    //_rotationText.text = [NSString stringWithFormat:@"%f",_selectedCell.bounds.size.width];
    
    
    imageAngle += angle;
    if (imageAngle > 360)
        imageAngle -= 360;
    else if (imageAngle < -360)
        imageAngle += 360;
    
    // rotate image and update text field
    _circleView.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
}

- (void) finalAngle: (CGFloat) angle
{
    // circular gesture ended, update text field
    
}

-(void)dismissRotationScreen:(UITapGestureRecognizer*)sender {
    [_rotationView removeFromSuperview];
    selectedTask = nil;
    self.disableCollectionViewAnimations = NO;
}

-(void)addTask {
    Task* task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:_managedObjectContext];
    task.project = _project;
    
    //Set Default Duration
    float result = 10.0f + 80.0f * (float)random()/RAND_MAX;
    task.durationMinutes = [NSNumber numberWithFloat:result];
     
    //Set sequential boolean
    float randomNumber = (float)random()/RAND_MAX;
    task.sequential = randomNumber > 0.7 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];

    //Set title
    task.title = _project.name;
    
    //Set index
    task.index = [NSNumber numberWithInteger:[[self.fetchedResultsController fetchedObjects] count]];

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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project == %@", _project];
    [fetchRequest setPredicate:predicate];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editTask"] ) {
        TaskDetailView *taskDetailView = (TaskDetailView *)[segue destinationViewController];
        TaskViewCell *cell = (TaskViewCell *)sender;
        taskDetailView.detailViewColor = cell.contentView.backgroundColor;
        taskDetailView.managedObjectContext = _managedObjectContext;
        NSIndexPath *index = [self.collectionView indexPathForCell:sender];
        taskDetailView.task = (Task *)[self.fetchedResultsController objectAtIndexPath:index];
        
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"editTask" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
}


@end
