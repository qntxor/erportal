//
//  QueueService.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface QueueService : BaseService
@property NSDate *beginDate;
@property NSDate *endDate;
@property QueueEntity *queue;

- (void)loadDataDay:(NSMutableArray *)dataItems collectionView:(UICollectionView *)collectionView activityIndicator:(UIActivityIndicatorView *)activityInicator;
- (void)loadDataTime:(NSMutableArray *)dataItems collectionView:(UICollectionView *)collectionView activityIndicator:(UIActivityIndicatorView *)activityInicator;
@end
