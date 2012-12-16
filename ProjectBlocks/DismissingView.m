//
//  DismissingView.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 15/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "DismissingView.h"


@implementation DismissingView

@synthesize target;
@synthesize selector;

- (id) initWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    self = [super initWithFrame:frame];
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.selector = selector;
    self.target = target;
    
    return self;
}

- (void) addToWindow:(UIWindow*)window
{
    NSUInteger count = window.subviews.count;
    id v = [window.subviews objectAtIndex:count - 1];
    if (![@"UITransitionView" isEqual:NSStringFromClass([v class])]) return;
    v = [window.subviews objectAtIndex:count - 2];
    if (![@"UIDimmingView" isEqual:NSStringFromClass([v class])]) return;
    
    UIView *front = [window.subviews lastObject];
    [window addSubview:self];
    [window bringSubviewToFront:front];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self removeFromSuperview];
    [target performSelector:selector withObject:self];
}

@end
