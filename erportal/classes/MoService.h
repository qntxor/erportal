//
//  MoService.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface MoService : BaseService

@property NSString *codeRegion;

- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator;
- (void)loadDataInLocalStore;

@end
