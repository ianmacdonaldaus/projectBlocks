//
//  ProjectPopOverViewController.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 02/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectPopOverViewController.h"
#import "ColorPalette.h"
#import "Colors.h"
#import "CoreDataHelper.h"
#import <QuartzCore/QuartzCore.h>

static NSString *CellIdentifier = @"CollectionViewCell";

@interface ProjectPopOverViewController ()

@end

@implementation ProjectPopOverViewController

@synthesize nameTextField = _nameTextField;
@synthesize project = _project;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView reloadData];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];

    self.view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 200, 30)];
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_nameTextField];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    NSLog(@"self.view.frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"self.view.bounds: %@", NSStringFromCGRect(self.view.bounds));
    //self.collectionView.frame = CGRectMake(0, 0, 500, 100);
    self.collectionView.backgroundColor = [UIColor blueColor];
    
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    NSLog(@"%@",self.collectionView);

 }

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _nameTextField.text = _project.name;
    
    NSMutableArray *array = [CoreDataHelper getObjectsForEntity:@"ColorPalette" withSortKey:@"index" andSortAscending:YES andContext:self.managedObjectContext];
    
    
    /*UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, 60)];
    float frameWidth = self.view.bounds.size.width;
    scrollView.contentSize = CGSizeMake(frameWidth * 10, 60);
    scrollView.backgroundColor = [UIColor blackColor];
    
    for (float colorPaletteIndex = 0 ; colorPaletteIndex < 10 ; colorPaletteIndex++) {

        ColorPalette *colorPalette = [array objectAtIndex:colorPaletteIndex];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
        NSArray *sortedColors = [[colorPalette.colors allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
        for (float colorIndex = 0; colorIndex < 5; colorIndex++) {
            Colors *colors = [sortedColors objectAtIndex:colorIndex];
            
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake((colorPaletteIndex * frameWidth) + (colorIndex * frameWidth / 5), 0, frameWidth / 5 - 1, 60)];
            //float hue = colorPaletteIndex / 10;
            //float saturation = colorIndex / 5;
            //UIColor *color =  [UIColor colorWithHue:hue saturation:saturation brightness:1.0f alpha:1.0];
            view.backgroundColor = colors.color;
            
            //[scrollView addSubview:view];
        }
    }
    scrollView.pagingEnabled = YES;
    //[self.view addSubview:scrollView];
*/
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, 100);
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(void) viewDidAppear:(BOOL)animated {

}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![_nameTextField.text isEqualToString:_project.name]) {
        [self.project setValue:_nameTextField.text forKey:@"name"];
        [self.managedObjectContext save:nil];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ColorPalette"inManagedObjectContext:self.managedObjectContext];
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


@end
