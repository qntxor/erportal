//
//  QueueTableViewCell.h
//  erportal
//


#import <UIKit/UIKit.h>

@interface QueueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameQueue;
@property (weak, nonatomic) IBOutlet UILabel *roomQueue;
@property (weak, nonatomic) IBOutlet UILabel *specialityQueue;

@end
