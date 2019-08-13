//
//  QuestionService.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface QuestionService : BaseService

@property ProfileEntity *profile;

//- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator;
- (void)loadDataInLocalStore:(UITableView *)tableView ;
-(void)loadSubjectsInLocalStore;
-(void)sendQuestion:(NSString *)text subject:(NSString *)subject;
- (NSArray *)dataItems;
@end
