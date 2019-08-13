//
//  MoTableViewCell.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
