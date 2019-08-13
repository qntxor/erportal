//
//  DoctorService.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface DoctorService : BaseService
@property NSString *moId;
@property NSString *specialityId;

- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator;

@end
