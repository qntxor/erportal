//
//  RecordTreeViewController.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicPortalMenuViewController.h"

@interface RecordTreeViewController : BasicPortalMenuViewController

@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pathCityToMo;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@property (weak, nonatomic) IBOutlet UIImageView *moImageView;
@property (weak, nonatomic) IBOutlet UIView *moView;
@property (weak, nonatomic) IBOutlet UILabel *moLabel;
@property (weak, nonatomic) IBOutlet UILabel *moName;
@property (weak, nonatomic) IBOutlet UIImageView *pathMoToSpec;

@property (weak, nonatomic) IBOutlet UIImageView *specImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pathSpecToDoctor;
@property (weak, nonatomic) IBOutlet UIView *specView;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UILabel *specName;

@property (weak, nonatomic) IBOutlet UIImageView *doctorImageView;
@property (weak, nonatomic) IBOutlet UIView *doctorView;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;

@end
