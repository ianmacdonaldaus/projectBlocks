//
//  ProjectViewCell.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 10/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPalette.h"

@interface ProjectViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *projectTitle;
@property (strong, nonatomic) ColorPalette *colorPalette;

@end
