//
//  AboutViewController.m
//  erportal
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarAppearace.tintColor = [UIColor whiteColor];
    self.navigationBarAppearace.barTintColor = [UIColor colorWithRed:0.0 green:122.0/185.0 blue:1.0 alpha:1.0];
    self.navigationBarAppearace.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    NSString *htmlString = @"<center><p>Приветствуем Вас в официальном приложении Единого портала здравоохранения!</p></center>";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    //[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:[htmlString length]];
    self.aboutLabel.attributedText = attributedString;
    self.aboutLabel.font = [UIFont systemFontOfSize:14.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"88002000000"]];
}


@end
