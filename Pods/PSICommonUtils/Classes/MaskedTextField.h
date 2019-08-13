//
//  MaskedTextField.h
//  RPS
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MaskedTextField : NSObject  <UITextFieldDelegate>

@property (strong, nonatomic, readonly) NSFormatter *formatter;

- (MaskedTextField *) initWithFormatter:(NSFormatter *)formatter;
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
