//
//  CVViewController.h
//  BlocksCV
//
//  Created by Ian MacDonald on 24/11/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVLayout.h"

@interface CVViewController : UICollectionViewController <CollectionViewDelegateCVLayout, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger cellCount;

@end
