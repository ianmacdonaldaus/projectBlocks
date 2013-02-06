//
//  TaskViewControllerNew.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 19/01/2013.
//  Copyright (c) 2013 Ian MacDonald. All rights reserved.
//
#import "TasksViewControllerNew.h"
#import "TasksViewLayout.h"
#import "TaskViewCell.h"
#import "TasksViewSectionSupplementaryCell.h"
#import "TaskEditModalView.h"

#import "Task.h"
#import "Section.h"
#import "Colors.h"

#import "RotationControlView.h"
#import "OneFingerRotationGestureRecognizer.h"
#import "BackgroundView.h"

#import "CoreDataHelper.h"
#import <QuartzCore/QuartzCore.h>

#define MINSCALE 1
#define MAXSCALE 10

@interface TasksViewControllerNew ()

@end

@implementation TasksViewControllerNew {
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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize project = _project;
@synthesize colorPalette = _colorPalette;
@synthesize arrayOfTasks = _arrayOfTasks;


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
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    sortedColors = [[self.colorPalette.colors allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
    [self setUpDataSource];
}

-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [self collectionView:self.collectionView layout:nil willEndReorderingAtIndexPath:nil];
}

-(void)handleBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark Collection View Methods

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.arrayOfTasks objectAtIndex:section] count];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.arrayOfTasks count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    Task* task = [[self.arrayOfTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // Add Task Title Label
    cell.taskLabel.text = task.title;
    
    // Add duration Label
    //cell.durationLabel.text = [task getTaskDurationAsString];
    NSString *debugString = [NSString stringWithFormat:@"%@ %@ %@",[task.sequential boolValue] ? @"YES" : @"NO" , [task.section.index stringValue], [task.index stringValue] ];
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
    
    sectionView.contentView.layer.backgroundColor = [color CGColor];
    return sectionView;
}


- (CGFloat)widthForItemAtIndexPath:(NSIndexPath*)indexPath {
    Task* task = [[self.arrayOfTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    float minutes = [task.durationMinutes floatValue];
    float width = minutes * durationScale;
    return width;
}

-(BOOL) sequentialForItemAtIndexPath:(NSIndexPath*)indexPath {
    Task* task = [[self.arrayOfTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return [task sequentialForItemAtIndexPath];
}

-(id)objectInProjectAtIndex:(NSIndexPath *)indexPath {
    Task *task = [[self.arrayOfTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return task;
}


#pragma mark -
#pragma mark Gesture Recognizers

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialTapPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialTapPoint];
        if (tappedCellPath != NULL) {
    
        selectedTask = [[self.arrayOfTasks objectAtIndex:tappedCellPath.section] objectAtIndex:tappedCellPath.row];
        }
        
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
            selectedTask = [[self.arrayOfTasks objectAtIndex:tappedCellPath.section] objectAtIndex:tappedCellPath.row];
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
    Task* task = [[self.arrayOfTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

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

    float randomNumber = (float)random()/RAND_MAX;
    float sectionIndex = floorf(randomNumber * 5);
    
    task.section = [self.arrayOfSections objectAtIndex:sectionIndex];
    
    [[self.arrayOfTasks objectAtIndex:sectionIndex] addObject:task];
    int taskIndex = [[self.arrayOfTasks objectAtIndex:sectionIndex] indexOfObject:task];
    
    //Set Default Duration
    float result = 10.0f + 80.0f * (float)random()/RAND_MAX;
    task.durationMinutes = [NSNumber numberWithFloat:result];
    
    //Set sequential boolean
    task.sequential = randomNumber > 0.7 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
    
    //Set title
    task.title = _project.name;
    
    //Set index
    task.index = [NSNumber numberWithInt:taskIndex];
    NSIndexPath *theIndexPathOfInsertedItem = [NSIndexPath indexPathForItem:[task.index integerValue] inSection:[task.section.index integerValue]];
    // Need to change the index to be the number of object within the current section...
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[ theIndexPathOfInsertedItem ]];
    } completion:nil];
    
    //    [self.collectionView reloadData];
    //    [self.managedObjectContext save:nil];
}


#pragma mark -
#pragma mark Miscellaneous

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout itemAtIndexPath:(NSIndexPath *)theFromIndexPath willMoveToIndexPath:(NSIndexPath *)theToIndexPath {
    
    Task *task = [[self.arrayOfTasks objectAtIndex:theFromIndexPath.section] objectAtIndex:theFromIndexPath.row];
    [[self.arrayOfTasks objectAtIndex:theFromIndexPath.section] removeObjectAtIndex:theFromIndexPath.row];
    [[self.arrayOfTasks objectAtIndex:theToIndexPath.section] insertObject:task atIndex:theToIndexPath.row];
    
    /*[self.collectionView performBatchUpdates:^{
    //    [self.collectionView moveItemAtIndexPath:theFromIndexPath toIndexPath:theToIndexPath];
    } completion:^(BOOL finished) {
    }];*/
    
    [self.collectionView moveItemAtIndexPath:theFromIndexPath toIndexPath:theToIndexPath];

}

-(void)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout willEndReorderingAtIndexPath:(NSIndexPath *)theIndexPath {
    
    for (NSMutableArray *section in self.arrayOfTasks) {
        int sectionIndex = [self.arrayOfTasks indexOfObject:section];
        for (Task *task in section) {
            int rowIndex = [[self.arrayOfTasks objectAtIndex:sectionIndex] indexOfObject:task];
            task.index = [NSNumber numberWithInt:rowIndex];
            task.section = [self.arrayOfSections objectAtIndex:sectionIndex];
        }
    }
    [self.collectionView reloadData];
    
}

-(void)setUpDataSource {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
   
    NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorSection];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project == %@", _project];
    [request setPredicate:predicate];
    
	// Execute the fetch request
	NSError *error = nil;
	self.arrayOfSections = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    // If the returned array was nil then there was an error
	if (self.arrayOfSections == nil)
		NSLog(@"Couldn't get objects for entity section");
    
    if (self.arrayOfSections.count == 0) {
        for (int i=0 ; i<5 ; i++) {
        Section* section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
        section.project = _project;
        section.index = [NSNumber numberWithInt:i];
        [self.arrayOfSections addObject:section];
        }
    }
    
    self.arrayOfTasks = [NSMutableArray array];
    
    for (Section *section in self.arrayOfSections) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section == %@", section];
        NSMutableArray *tempTasks = [NSMutableArray array];
        tempTasks = [CoreDataHelper searchObjectsForEntity:@"Task" withPredicate:predicate andSortKey:@"index" andSortAscending:YES andContext:self.managedObjectContext];
        
        [self.arrayOfTasks addObject:tempTasks];
    }
	
}

@end
