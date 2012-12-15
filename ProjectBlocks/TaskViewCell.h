//
//  CVCell.h
//  BlocksCV
//
//  Created by Ian MacDonald on 25/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskViewCell : UICollectionViewCell

@property (nonatomic, retain) UILabel* taskLabel;
@property  (nonatomic, retain) UILabel* durationLabel;

@end
