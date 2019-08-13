//
//  BasicTractViewController.h
//  StavropolTranstur
//
//  
//  Copyright © 2016 Routeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataContext.h"
#import "ERApplicationAssembly.h"

//Navigation
//#import "UINavigationBar+Awesome.h"
//#define NAVBAR_CHANGE_POINT 30

@interface BasicPortalViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInicator;
@end
