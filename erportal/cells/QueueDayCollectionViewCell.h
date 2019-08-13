//
//  QueueDayCollectionViewCell.h
//  erportal


#import <UIKit/UIKit.h>

@interface QueueDayCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;
@end
