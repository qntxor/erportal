//
//  QuestionEditViewController.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "QuestionEditViewController.h"
#import "WebViewController.h"

@interface QuestionEditViewController (){
    //HPGrowingTextView *textView;
}

//picker
@property (nonatomic, strong) NSMutableArray *questionSubjects;
@property (nonatomic, assign) NSInteger selectedIndexSubjects;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

@end

@implementation QuestionEditViewController

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Загружаем темы вопросов
    self.questionSubjects = [NSMutableArray new];
    PFQuery *queryLocal = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [queryLocal fromLocalDatastore];
    //AppEntity *app = [queryLocal getFirstObject];
    [self.questionSubjects addObjectsFromArray:@[@"Дефекты в мед. обсуживании", @"Лекарственное обеспечение", @"ВМП", @"Должностные вопросы", @"Вопросы зарплаты", @"Деятельность стационаров", @"Благодарственные", @"Открытые данные", @"Противодействие коррупции"]];
    
    
    //To make the border look very close to a UITextField
    [self.textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textView.layer setBorderWidth:0.5];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    
    [DisignContext setBorderBottomView:self.textQuestion];
//    [DisignContext setBorderBottomView:self.textView];
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkToWeb)];
//    singleTap.numberOfTapsRequired = 1;
//    [self.actionLabel setUserInteractionEnabled:YES];
//    [self.actionLabel addGestureRecognizer:singleTap];
    
    self.actionLabel.text = @"* Если у вас возникли вопросы или трудности в процессе получения медицинской помощи, просим описать их в данном разделе. Опишите суть вопроса или проблемы с обязательным указанием медицинского учреждения, при обращении в которое возникли трудности.";
    [self.actionButton addTarget:self action:@selector(sendQuestion) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendQuestion{
    QuestionService *service = [QuestionService new];
    service.controller = self;
    [service sendQuestion:self.textView.text subject:self.subjectField.text];
}

- (void) linkToWeb{
    WebViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    [viewController setRequestString:@"https://ticket.routeam.ru/htmls/pers_data.html"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)selectQuestionSubjects:(UIControl *)sender  {
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"Тема обращения" rows:self.questionSubjects initialSelection:self.selectedIndexSubjects doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.selectedIndexSubjects = selectedIndex;
        self.subjectField.text = (self.questionSubjects)[(NSUInteger) self.selectedIndexSubjects];
        
    } cancelBlock:nil origin:sender];
    
    [DisignContext settingPicker:picker];
    
    [picker showActionSheetPicker];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 101) {
        [self selectQuestionSubjects:textField];
        return NO;
    }
    return YES;
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
