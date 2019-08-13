//
//  TabViewController.h
//  erportal
//


#import <UIKit/UIKit.h>

@interface TabViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property UIViewController *currentViewController;
@property NSString *organizationId;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
