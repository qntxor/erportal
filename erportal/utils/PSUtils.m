//
//  PSUtils.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "PSUtils.h"

@implementation PSUtils

+ (CGRect)mainScreenBoundsForCurrentOrientation
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    return [self mainScreenBoundsForOrientation:orientation];
}

+ (CGRect)mainScreenBoundsForOrientation:(UIDeviceOrientation)orientation
{
    CGRect bounds = CGRectZero;
    CGFloat width   = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height  = [[UIScreen mainScreen] bounds].size.height;
    
    if (UIDeviceOrientationIsLandscape(orientation))
        bounds.size = CGSizeMake(MAX(width, height), MIN(width, height));
    else
        bounds.size = CGSizeMake(MIN(width, height), MAX(width, height));
    
    return bounds;
}

@end
