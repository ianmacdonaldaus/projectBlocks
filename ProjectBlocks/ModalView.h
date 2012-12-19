//
//  ModalView.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 18/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ModalView : UIView

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *editView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end
