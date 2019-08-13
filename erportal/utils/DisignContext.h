//
//  DisignContext.h
//  FreshMandarin
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AXRatingView.h"
#import "ActionSheetPicker.h"

@interface DisignContext : NSObject
+ (DisignContext *)context;
+ (void) setNavigationBarColor:(UINavigationBar *)navigationBar;
+ (void) setActivityInicator:(UIActivityIndicatorView *)activityIndicator;
+ (void) setBackgroudCell:(UITableViewCell *)cell;
//+ (void) setNavigationBarController;
+ (void) setViewCurrentTheme:(UIView *)view withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *)navigationBar;
+ (void) setViewCurrentTheme:(UIView *)view withColor:(UIColor *)color withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar;
+ (void) setViewCurrentTheme:(UIView *)view withImageName:(NSString *)imageName withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar;
+ (void) setRoundedView:(UIView *) view;
+ (void) setRoundedView:(UIView *) view border:(float)size color:(UIColor *)color;
+ (void) setBorderBottomView:(UIView *)view;
+ (void) setBorderTopView:(UIView *)view;
+ (void) setBorderBottomView:(UIView *)view width:(float)width image:(UIImage *)image;
+ (void) setBorderTopView:(UIView *)view width:(float)width image:(UIImage *)image;
+ (void) settingPicker:(AbstractActionSheetPicker *)picker;
+ (void)showActivityIndicatorView:(UIView *)view;
+ (void)hideActivityIndicatorView:(UIView *)view;
@end
