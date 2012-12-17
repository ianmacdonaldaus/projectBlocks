//
//  UIColorTransformer.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 16/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "UIColorTransformer.h"

@implementation UIColorTransformer

+(BOOL)allowsReverseTransformation {
    return YES;
}

+(Class)transformedValueClass {
    return [NSData class];
}

-(id)transformedValue:(id)value {
    UIColor *color = (UIColor *)value;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *result = [NSString stringWithFormat:@"%f,%f,%f",components[0],components[1],components[2]];
    return [result dataUsingEncoding:[NSString defaultCStringEncoding]];
}

-(id)reverseTransformedValue:(id)value {
    NSString *string = [[NSString alloc] initWithData:value encoding:[NSString defaultCStringEncoding]];
    NSArray *components = [string componentsSeparatedByString:@","];
    CGFloat red = [[components objectAtIndex:0] floatValue];
    CGFloat green = [[components objectAtIndex:1] floatValue];
    CGFloat blue = [[components objectAtIndex:2] floatValue];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
