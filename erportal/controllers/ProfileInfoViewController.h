//
//  ProfileInfoViewController.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalMenuViewController.h"

@interface ProfileInfoViewController : BasicPortalMenuViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
