//
//  MenuViewController.h
//  CommonService
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellMain;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellActions;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellProfile;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellWrite;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellExit;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellQuestion;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellMap;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UILabel *fioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellChangeProfile;


@end
