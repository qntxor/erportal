//
//  PSIDisignContext.m
//  Pods
//
//  Created by Сергей Першиков on 31.10.16.
//
//

#import "PSIDisignContext.h"

@implementation PSIDisignContext
+(PSIDisignContext*)context{
    
    static PSIDisignContext *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[PSIDisignContext alloc] init];
    });
    return sharedInstance;
}

+ (void) setViewCurrentTheme:(UIView *)view withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar{
    [PSIDisignContext setNavigationBarColor:navigationBar];
    [PSIDisignContext setActivityInicator:activityIndicator];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_fish_skin"]];
}

+ (void) setViewCurrentTheme:(UIView *)view withImageName:(NSString *)imageName withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar{
    [PSIDisignContext setNavigationBarColor:navigationBar];
    [PSIDisignContext setActivityInicator:activityIndicator];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

+ (void) setViewCurrentTheme:(UIView *)view withColor:(UIColor *)color withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar{
    [PSIDisignContext setNavigationBarColor:navigationBar];
    [PSIDisignContext setActivityInicator:activityIndicator];
    if(color == nil){
        view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }else{
        UIGraphicsBeginImageContext(view.frame.size);
        [[UIImage imageNamed:@"background_order_checked"] drawInRect:view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
}

+ (void) setNavigationBarColor:(UINavigationBar *)navigationBar{
    [navigationBar setBarTintColor:[UIColor colorWithRed:0.00 green:0.34 blue:0.61 alpha:1.0]];
    navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forKey:NSForegroundColorAttributeName];
    navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

+ (void) setRoundedView:(UIView *) view{
    view.layer.cornerRadius = view.frame.size.height/2;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor=[[UIColor grayColor] CGColor];
}

+ (void) setRoundedView:(UIView *) view border:(float)size color:(UIColor *)color {
    view.layer.cornerRadius = view.frame.size.height/2;
    //view.layer.masksToBounds = YES;
    //view.clipsToBounds = YES;
    view.layer.borderWidth = size;
    view.layer.borderColor=[color CGColor];
}

+ (void) setBorderBottomView:(UIView *)view{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, view.frame.size.height - 1, view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"separator_line"]] CGColor];
    [view.layer addSublayer:bottomBorder];
}

+ (void) setBorderBottomView:(UIView *)view width:(float)width image:(UIImage *)image{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, view.frame.size.height, view.frame.size.width, width);
    bottomBorder.backgroundColor = [[UIColor colorWithPatternImage:image] CGColor];
    [view.layer addSublayer:bottomBorder];
}

+ (void) setBorderTopView:(UIView *)view{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 1.0f, view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"separator_line"]] CGColor];
    [view.layer addSublayer:bottomBorder];
}

+ (void) setBorderTopView:(UIView *)view width:(float)width image:(UIImage *)image{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, -width, view.frame.size.width, width);
    bottomBorder.backgroundColor = [[UIColor colorWithPatternImage:image] CGColor];
    [view.layer addSublayer:bottomBorder];
}

+ (void) setActivityInicator:(UIActivityIndicatorView *)activityIndicator{
    //[activityIndicator setColor:[UIColor colorWithRed:0.204 green:0.667 blue:0.863 alpha:1]];
}

+ (void) setBackgroudCell:(UITableViewCell *)cell{
    UIImage *background = [UIImage imageNamed:@"cell"];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
}

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

//get array in view
+ (NSArray*)findAllTextFieldsInView:(UIView*)view{
    NSMutableArray* textfieldarray = [NSMutableArray new];
    for(id x in [view subviews]){
        if([x isKindOfClass:[UITextField class]])
            [textfieldarray addObject:x];
        
        if([x respondsToSelector:@selector(subviews)]){
            // if it has subviews, loop through those, too
            [textfieldarray addObjectsFromArray:[self findAllTextFieldsInView:x]];
        }
    }
    return textfieldarray;
}


@end
