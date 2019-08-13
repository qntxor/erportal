//
//  HistoryViewController.h
//  erportal
//


#import <UIKit/UIKit.h>
#import "BasicPortalMenuViewController.h"

@interface HistoryViewController : BasicPortalMenuViewController  <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property TalonEntity *segueValue;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarAppearace;

@end
