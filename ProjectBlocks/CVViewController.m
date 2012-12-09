//
//  CVViewController.m
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "CVViewController.h"
#import "CVLayout.h"
#import "CVCell.h"

@interface CVViewController ()

@end

@implementation CVViewController {
//    NSMutableArray *arrayOfRows;
    NSMutableArray *arrayOfSections;
}

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
    
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"MY_CELL"];
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

}

-(void)handleBackButton {
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return arrayOfSections.count;
}

-(NSInteger)collectionView:(UICollectionView*)view numberOfItemsInSection:(NSInteger)section {
    return [[arrayOfSections objectAtIndex:section] count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout widthForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSNumber* number = (NSNumber*)[[arrayOfSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return [number floatValue];
    
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
            float randomWidth = 10.0f + 100.0f * (float)random()/RAND_MAX;
            NSNumber* number = [NSNumber numberWithFloat:randomWidth];
            [[arrayOfSections objectAtIndex:0] addObject:number];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:([self.collectionView numberOfItemsInSection:0]) inSection:0]]];
            } completion:nil];
        }
    }
}

#pragma mark -
#pragma mark Miscellaneous

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
