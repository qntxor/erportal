//
//  DisignContext.m
//  FreshMandarin
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import "DisignContext.h"


@implementation DisignContext
+(DisignContext*)context{
    
    static DisignContext *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[DisignContext alloc] init];
    });
    return sharedInstance;
}

+ (void) setViewCurrentTheme:(UIView *)view withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar{
    [DisignContext setNavigationBarColor:navigationBar];
    [DisignContext setActivityInicator:activityIndicator];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_fish_skin"]];
}

+ (void) setViewCurrentTheme:(UIView *)view withImageName:(NSString *)imageName withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar{
    [DisignContext setNavigationBarColor:navigationBar];
    [DisignContext setActivityInicator:activityIndicator];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

+ (void) setViewCurrentTheme:(UIView *)view withColor:(UIColor *)color withIndicator:(UIActivityIndicatorView *) activityIndicator withNavigationBar:(UINavigationBar *) navigationBar{
    [DisignContext setNavigationBarColor:navigationBar];
    [DisignContext setActivityInicator:activityIndicator];
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
    [navigationBar setBarTintColor:OUR_APP_BAR_COLOR];
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

//Функция для добавления необходимых кнопок в кастомный дата пикер
+ (void) settingPicker:(AbstractActionSheetPicker *)picker{
    UIButton *okButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"Готово" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithRed:0.204 green:0.667 blue:0.863 alpha:1] forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(0, 0, 74, 32)];
    [(ActionSheetStringPicker *) picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:okButton]];
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.204 green:0.667 blue:0.863 alpha:1] forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(0, 0, 74, 32)];
    [(ActionSheetStringPicker *) picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
}

+ (void)showActivityIndicatorView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = @"Загружаем...";
    //hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    //    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    //    hud.backgroundColor = [UIColor whiteColor];
}

+ (void)hideActivityIndicatorView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
