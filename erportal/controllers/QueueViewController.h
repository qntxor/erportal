//
//  QueueViewController.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"

@interface QueueViewController : BasicPortalViewController  <UICollectionViewDataSource,UICollectionViewDelegate>
@property QueueEntity *queue;
@property SlotEntity *slot;
@property (weak, nonatomic) IBOutlet UILabel *nameMo;
@property (weak, nonatomic) IBOutlet UILabel *intervalDate;
@property (weak, nonatomic) IBOutlet UIImageView *backWeek;
@property (weak, nonatomic) IBOutlet UIImageView *nextWeek;
@property NSString *segueValue;
@property (weak, nonatomic) IBOutlet UILabel *nameQueue;
@property NSDate *currentDate;

@property (weak, nonatomic) IBOutlet UICollectionView *daysCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorChangeDay;

@end
