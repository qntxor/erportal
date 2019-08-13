//
//  CityService.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface CityService : BaseService

@property NSString *moId;

- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator;

@end
