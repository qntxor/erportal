//
//  SlotFinishViewController.h
//  erportal
//


#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"
#import "ZXingObjC.h"

@interface SlotFinishViewController : BasicPortalViewController
@property TalonEntity *talon;
@property (weak, nonatomic) IBOutlet UILabel *nameMo;
@property (weak, nonatomic) IBOutlet UIImageView *barCode;
@property (weak, nonatomic) IBOutlet UILabel *numberSlot;
@property (weak, nonatomic) IBOutlet UILabel *dateSlot;
@property (weak, nonatomic) IBOutlet UILabel *timeSlot;
@property (weak, nonatomic) IBOutlet UILabel *nameQueue;
@property (weak, nonatomic) IBOutlet UILabel *speciality;
@property (weak, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *statusSlot;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *patient;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIView *commonView;

@end
