//
//  WebViewController.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"

@interface WebViewController : BasicPortalViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSString *requestString;
@end
