//
//  CityViewController.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BasicPortalViewController.h"

@interface CityViewController : BasicPortalViewController  <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end
