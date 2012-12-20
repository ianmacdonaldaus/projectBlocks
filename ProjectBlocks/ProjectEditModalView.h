//
//  ProjectEditModalView.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalView.h"
#import "Project.h"

@interface ProjectEditModalView : ModalView <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *colorPalettes;
@property (strong, nonatomic) Project *project;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *projectTitleTextField;


@end
