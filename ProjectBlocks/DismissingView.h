//
//  DismissingView.h
//  ProjectBlocks
//
//  Created by Ian MacDonald on 15/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DismissingView : UIView {
}

@property (nonatomic, retain) id target;
@property (nonatomic) SEL selector;

- (id) initWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
- (void) addToWindow:(UIWindow*)window;

@end