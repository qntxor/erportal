//
//  QueueTimeViewController.h
//  erportal
//

#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"

@interface QueueTimeViewController : BasicPortalViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property QueueEntity *queue;
@property SlotEntity *slot;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSDate *currentDate;
@property NSString *segueValue;
@property (weak, nonatomic) IBOutlet UILabel *nameQueue;
@property (weak, nonatomic) IBOutlet UILabel *dayQueue;
@property (weak, nonatomic) IBOutlet UILabel *nameMo;
@property (weak, nonatomic) IBOutlet UILabel *intervalDate;

@end
