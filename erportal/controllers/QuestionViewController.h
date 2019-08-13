//
//  QuestionViewController.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalMenuViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface QuestionViewController : BasicPortalMenuViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end
