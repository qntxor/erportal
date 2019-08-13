//
//  ProfileViewController.m
//  erportal
//


#import "ProfileViewController.h"
#import "MaskedTextField.h"
#import "MaskFormatter.h"
#import "SlotFinishViewController.h"

@interface ProfileViewController (){
    UITextField *activeField;
    ServicePortal *service;
    NSMutableData *responseData;
    UIToolbar *keyboardToolbar;
}
@property NSManagedObjectContext *context;
@property (nonatomic)  MaskedTextField *maskPhone;
@property (nonatomic)  MaskedTextField *maskENP;
@property (nonatomic)  MaskedTextField *maskSNILS;
@property (nonatomic)  MaskedTextField *maskPassport;
@property (nonatomic)  MaskedTextField *maskDate;


@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    [self.phoneField setDelegate:self.maskPhone];
    //[self.enpField setDelegate:self.maskENP];
    [self.passportField setDelegate:self.maskPassport];
    [self.snilsField setDelegate:self.maskSNILS];
    [self.dbField setDelegate:self.maskDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DisignContext setBorderBottomView:self.snameView];
    [DisignContext setBorderBottomView:self.nameView];
    [DisignContext setBorderBottomView:self.pnameView];
    [DisignContext setBorderBottomView:self.polisView];
    [DisignContext setBorderBottomView:self.dbView];
    [DisignContext setBorderBottomView:self.phoneView];
    [DisignContext setBorderBottomView:self.emailView];
    
    
    keyboardToolbar = [UIToolbar new];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    [keyboardToolbar sizeToFit];
    
    //    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"previous"
    //                                                                       style:UIBarButtonItemStyleBordered
    //                                                                      target:self
    //                                                                      action:@selector(previousField:)];
    //
    //    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next"
    //                                                                   style:UIBarButtonItemStyleBordered
    //                                                                  target:self
    //                                                                  action:@selector(nextField:)];
    //
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
    self.context = [CoreDataContext shareManager].context;
    [self setFieldValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProfile:(id)sender {
    [self setProfileValue];
    if ([self.profileEntity validate]) {
        if (self.profileEntity.profile == nil) {
            self.profileEntity.profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.context];
        }
        [self.profileEntity fillObject];
        NSError *error = nil;
        if (![self.context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else{
            [self setFieldValue];
            [self.navigationController popViewControllerAnimated:YES];
        }


    }else{
        [self presentViewController:[PSIAlertHelper viewAlertBasicMessage:self.profileEntity.error] animated:YES completion:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) setFieldValue{
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    AppEntity *app = [query getFirstObject];
    self.profileEntity.profile = [app activeProfileObject];
    [self.profileEntity initFromObject:self.profileEntity.profile];
    self.snilsField.text = self.profileEntity.snils;
    self.enpField.text = self.profileEntity.enp;
    self.passportField.text = self.profileEntity.passport;
    self.snameField.text = self.profileEntity.sname;
    self.nameField.text = self.profileEntity.name;
    self.pnameField.text = self.profileEntity.pname;
    self.dbField.text = self.profileEntity.birthday;
    self.phoneField.text = self.profileEntity.phone;
    self.emailField.text = self.profileEntity.email;
    self.enpField.text = self.profileEntity.enp;
    self.sexSegment.selectedSegmentIndex = ([self.profileEntity.sex integerValue]-1);
}

- (void) setProfileValue{
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
}

- (void) setProfileObject{
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.0, 0.0, kbSize.height, 0.0);
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
    self.scrollView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
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


@end
