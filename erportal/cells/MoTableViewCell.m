//
//  MoTableViewCell.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "MoTableViewCell.h"

@implementation MoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)prepareForReuse{
    self.nameLabel = nil;
    self.phoneLabel = nil;
    self.addressLabel = nil;
}

@end
