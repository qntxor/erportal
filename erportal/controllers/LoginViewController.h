//
//  LoginViewController.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GHWalkThroughView.h"
//#import "EAIntroView.h"
//<GHWalkThroughViewDataSource>
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property ProfileEntity *profileEntity;
@property TalonEntity *talon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightPersonalConstraint;
@property (weak, nonatomic) IBOutlet UIView *personalView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;


@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *polisView;
@property (weak, nonatomic) IBOutlet UIView *snameView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *pnameView;
@property (weak, nonatomic) IBOutlet UIView *dbView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *emailView;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (weak, nonatomic) IBOutlet UITextField *dbField;
@property (weak, nonatomic) IBOutlet UITextField *pnameField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *snameField;
@property (weak, nonatomic) IBOutlet UITextField *enpField;
@property (weak, nonatomic) IBOutlet UITextField *snilsField;
@property (weak, nonatomic) IBOutlet UITextField *passportField;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
