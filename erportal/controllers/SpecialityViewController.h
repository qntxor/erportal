//
//  SpecialityViewController.h
//  erportal
//


#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"

@interface SpecialityViewController : BasicPortalViewController  <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property NSString *organizationId;
@property NSString *segueValue;
@end
