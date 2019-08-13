//
//  AboutViewController.h
//  erportal
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalMenuViewController.h"

@interface AboutViewController : BasicPortalMenuViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarAppearace;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end
