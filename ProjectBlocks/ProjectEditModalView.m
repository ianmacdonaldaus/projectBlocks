//
//  ProjectEditModalView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "ProjectEditModalView.h"
#import "ColorPalette.h"
#import "Colors.h"
#import "CoreDataHelper.h"
#import <QuartzCore/QuartzCore.h>

static NSString *CellIdentifier = @"CollectionViewCell";
static float collectionViewHeight = 100;

@implementation ProjectEditModalView

@synthesize colorPalettes = _colorPalettes;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize collectionView = _collectionView;
@synthesize project = _project;
@synthesize projectTitleTextField = _projectTitleTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

-(void)didMoveToWindow {

    _colorPalettes = [CoreDataHelper getObjectsForEntity:@"ColorPalette" withSortKey:@"index" andSortAscending:YES andContext:self.managedObjectContext];

    float itemSize = self.editView.frame.size.width;
    NSLog(@"%@", NSStringFromCGRect(self.editView.frame));
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemSize, collectionViewHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.editView.frame.size.height - collectionViewHeight-40, self.editView.frame.size.width, collectionViewHeight) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    UIView *shadowLayer = [[UIView alloc] initWithFrame:self.collectionView.frame];
    shadowLayer.layer.shadowOpacity = 0.3;
    shadowLayer.layer.shadowOffset = CGSizeMake(0, 0);
    shadowLayer.layer.shadowRadius = 15;
    shadowLayer.layer.shouldRasterize = YES;
    shadowLayer.backgroundColor = [UIColor blackColor];
    [self.editView insertSubview:self.collectionView atIndex:0];
    [self.editView insertSubview:shadowLayer atIndex:0];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.pagingEnabled = YES;
    self.editView.center = CGPointMake(self.editView.center.x, -200);
    [self setBackgroundColorToProjectColor];
    
    //set starting position
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.project.colorPalette.index integerValue] inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(30, 20, self.editView.frame.size.width - 60, 45)];
    view1.layer.cornerRadius = 10;
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.opacity = 0.3;
    view1.layer.shadowOpacity = 0.2;
    [self.editView insertSubview:view1 atIndex:0];
    
    self.projectTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(45, 27, self.editView.frame.size.width - 80, 30)];
    [self.editView addSubview:self.projectTitleTextField];
    self.projectTitleTextField.text = self.project.name;
    self.projectTitleTextField.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:24];
    self.projectTitleTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.projectTitleTextField.textColor = [UIColor whiteColor];
    [self.projectTitleTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}

-(void)setBackgroundColorToProjectColor {
    ColorPalette *colorPalette = self.project.colorPalette;
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    NSArray *sortedColors = [[colorPalette.colors allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    Colors *colors = [sortedColors objectAtIndex:0];
    self.editView.backgroundColor = colors.color;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_colorPalettes count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    float frameWidth = self.editView.frame.size.width;
    cell.contentView.frame = CGRectMake(0, 0, frameWidth, cell.frame.size.height);

    ColorPalette *colorPalette = [self.colorPalettes objectAtIndex:indexPath.row];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    NSArray *sortedColors = [[colorPalette.colors allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    int i = 0;
    float cellWidth = frameWidth / [sortedColors count];

    for (Colors *colors in sortedColors) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((cellWidth * i), 0 , cellWidth, collectionViewHeight)];
        view.backgroundColor = colors.color;
        [cell.contentView addSubview:view];
        i += 1;
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] objectAtIndex:0];
    ColorPalette *colorPalette = [self.colorPalettes objectAtIndex:indexPath.row];
    self.project.colorPalette = colorPalette;
    NSLog(@"%@", self.project.colorPalette.index);
    [self.managedObjectContext save:nil];
    [self setBackgroundColorToProjectColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.project.name = self.projectTitleTextField.text;
    [self.managedObjectContext save:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return NO;
}

@end
