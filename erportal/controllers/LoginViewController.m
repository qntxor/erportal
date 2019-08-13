//
//  LoginViewController.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "LoginViewController.h"
#import "MaskedTextField.h"
#import "MaskFormatter.h"
#import "GHWalkThroughView.h"

static NSString * const sampleDesc1 = @"Записывайте себя и своих близких на прием к врачу на территории Ставропольского края.";
//static NSString * const sampleTitle1 = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tincidunt laoreet diam, id suscipit ipsum sagittis a. ";

static NSString * const sampleDesc2 = @"Приходите на прием, не распечатывая талон. Покажите его на экране смартфона.";

static NSString * const sampleDesc3 = @"Простой поиск и удобная карта помогут в выборе подходящего учреждения.";

static NSString * const sampleDesc4 = @"Задавайте вопросы нашим специалистам напрямую из приложения.";



@interface LoginViewController () <GHWalkThroughViewDataSource> {
    UITextField *activeField;
//    EAIntroView *intro;
}
@property (nonatomic, strong) GHWalkThroughView* ghView;
@property (nonatomic, strong) NSArray* descStrings;
@property (nonatomic, strong) NSArray* titleStrings;

@property (nonatomic)  MaskedTextField *maskPhone;
@property (nonatomic)  MaskedTextField *maskENP;
@property (nonatomic)  MaskedTextField *maskSNILS;
@property (nonatomic)  MaskedTextField *maskPassport;
@property (nonatomic)  MaskedTextField *maskDate;
@end

@implementation LoginViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self registerForKeyboardNotifications];
    [self.phoneField setDelegate:self.maskPhone];
    //[self.enpField setDelegate:self.maskENP];
    [self.passportField setDelegate:self.maskPassport];
    [self.snilsField setDelegate:self.maskSNILS];
    [self.dbField setDelegate:self.maskDate];
    
    //[self.view layoutIfNeeded];
    //[intro showInView:self.view animateDuration:0.0];

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [DisignContext setBorderBottomView:self.loginView];
    [DisignContext setBorderBottomView:self.passwordView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightPersonalConstraint.constant = 0.0;
    
    //Выставляем действия
    UITapGestureRecognizer *registerLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerTap)];
    registerLabelTap.numberOfTapsRequired = 1;
    [self.registrationLabel addGestureRecognizer:registerLabelTap];
    self.registrationLabel.userInteractionEnabled = YES;
    
    [self.actionButton addTarget:self
                          action:@selector(tapActionButton)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.actionButton setTitle:@"Войти" forState:UIControlStateNormal];
    self.registrationLabel.text = @"Новый пользователь?";
    self.personalView.hidden = YES;
    
    //set disign
    
    UIToolbar *keyboardToolbar = [UIToolbar new];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyboard:)];
    
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraSpace, done, nil]];
    
    NSArray* allTextFields = [Utils findAllTextFieldsInView:self.view];
    for (UITextField *view in allTextFields) {
        view.autocorrectionType = UITextAutocorrectionTypeNo;
        [view setInputAccessoryView:keyboardToolbar];
    }
    
    self.snameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.pnameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    self.profileEntity = [ProfileEntity new];
    
    // basic
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"Hello world";
//    page1.desc = @"dfsdfsdfsdf";
//    page1.bgImage = [UIImage imageNamed:@"background-blur"];
//    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
//    
//    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"This is page 2";
//    page2.desc = @"dfsdfsdfsdf";
//    page2.bgImage = [UIImage imageNamed:@"background-blur"];
//    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
//    
//    intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2]];
//    //[intro showInView:self.view animateDuration:0.0];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isAppAlreadyLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAppAlreadyLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.descStrings = [NSArray arrayWithObjects:sampleDesc1,sampleDesc2, sampleDesc3, sampleDesc4, nil];
        _ghView = [[GHWalkThroughView alloc] initWithFrame:self.view.bounds];
        _ghView.floatingHeaderView = nil;
        [_ghView setDataSource:self];
        self.ghView.isfixedBackground = NO;
        [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
        [_ghView showInView:self.view animateDuration:0.0];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma intro
- (NSInteger) numberOfPages
{
    return 4;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    cell.title = @" ";
    //cell.titleImage = [UIImage imageNamed:@"title1"];
    cell.desc = [self.descStrings objectAtIndex:index];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"gw_page%d",index+1]];
    return image;
}

#pragma action
-(void)tapActionButton{
    UserService *service = [UserService new];
    service.controller = self;
    if (self.heightPersonalConstraint.constant == 0.0) {
        [service singin:self.loginField.text password:self.passwordField.text];
    }else{
        self.profileEntity.snils = self.snilsField.text;
        self.profileEntity.enp = self.enpField.text;
        self.profileEntity.passport = self.passportField.text;
        self.profileEntity.sname = self.snameField.text;
        self.profileEntity.name = self.nameField.text;
        self.profileEntity.pname = self.pnameField.text;
        self.profileEntity.birthday = self.dbField.text;
        self.profileEntity.phone = self.phoneField.text;
        self.profileEntity.email = self.emailField.text;
        self.profileEntity.enp = self.enpField.text;
        self.profileEntity.sex = [NSString stringWithFormat:@"%d",(int)(self.sexSegment.selectedSegmentIndex+1)];
        if ([self.profileEntity validate]) {
            [service singup:self.profileEntity usename:self.loginField.text password:self.passwordField.text];
        }else{
            [self presentViewController:[PSIAlertHelper viewAlertBasicMessage:self.profileEntity.error] animated:YES completion:nil];
        }
    }    
}

-(void) registerTap{
    if (self.heightPersonalConstraint.constant == 0.0) {
        self.heightPersonalConstraint.constant = 530.0;
        self.personalView.hidden = NO;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
        
        [DisignContext setBorderBottomView:self.snameView];
        [DisignContext setBorderBottomView:self.nameView];
        [DisignContext setBorderBottomView:self.pnameView];
        [DisignContext setBorderBottomView:self.polisView];
        [DisignContext setBorderBottomView:self.dbView];
        [DisignContext setBorderBottomView:self.phoneView];
        [DisignContext setBorderBottomView:self.emailView];
        [self.actionButton setTitle:@"Зарегистрироваться" forState:UIControlStateNormal];
        self.registrationLabel.text = @"Уже зарегистрированы?";
    }else{
        self.heightPersonalConstraint.constant = 0.0;
        self.personalView.hidden = YES;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
        [self.actionButton setTitle:@"Войти" forState:UIControlStateNormal];
        self.registrationLabel.text = @"Новый пользователь?";
    }

}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(void) resignKeyboard:(id)sender{
    [self.view endEditing:YES];
    //[self.scrollView setContentOffset:CGPointMake(0.0, 64.0) animated:YES];
}

- (MaskedTextField *) maskPhone
{
    if (_maskPhone == nil) {
        MaskFormatter *cnpjFormatter = [[MaskFormatter alloc] initWithMask:@"(___)-___-__-__"];
        _maskPhone = [[MaskedTextField alloc] initWithFormatter:cnpjFormatter];
    }
    return _maskPhone;
}

- (MaskedTextField *) maskSNILS
{
    if (_maskSNILS == nil) {
        MaskFormatter *cnpjFormatter = [[MaskFormatter alloc] initWithMask:@"___-___-___ __"];
        _maskSNILS = [[MaskedTextField alloc] initWithFormatter:cnpjFormatter];
    }
    return _maskSNILS;
}

- (MaskedTextField *) maskENP
{
    if (_maskENP == nil) {
        MaskFormatter *cnpjFormatter = [[MaskFormatter alloc] initWithMask:@"999999999999999"];
        _maskENP = [[MaskedTextField alloc] initWithFormatter:cnpjFormatter];
    }
    return _maskENP;
}

- (MaskedTextField *) maskPassport
{
    if (_maskPassport == nil) {
        MaskFormatter *cnpjFormatter = [[MaskFormatter alloc] initWithMask:@"__ __ ______"];
        _maskPassport = [[MaskedTextField alloc] initWithFormatter:cnpjFormatter];
    }
    return _maskPassport;
}

- (MaskedTextField *) maskDate
{
    if (_maskDate == nil) {
        MaskFormatter *cnpjFormatter = [[MaskFormatter alloc] initWithMask:@"__.__.____"];
        _maskDate = [[MaskedTextField alloc] initWithFormatter:cnpjFormatter];
    }
    return _maskDate;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
