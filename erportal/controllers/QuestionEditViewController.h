//
//  QuestionEditViewController.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"
#import "HPGrowingTextView.h"
#import "MBAutoGrowingTextView.h"

@interface QuestionEditViewController : BasicPortalViewController <HPGrowingTextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textQuestion;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UITextField *subjectField;

@property (weak, nonatomic) IBOutlet UIView *containerTextView;
@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *textView;


@end
