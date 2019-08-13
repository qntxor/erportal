//
//  WebViewController.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *barButtonLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
//    self.navigationItem.leftBarButtonItem = barButtonLeft;
    self.navigationItem.title = @"Просмотр";
    
    NSURL *url = [NSURL URLWithString:self.requestString];
    [self.activityInicator startAnimating];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:requestObj];
    [self.activityInicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
