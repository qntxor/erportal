//
//  SlotCreateViewController.h
//  erportal


#import <UIKit/UIKit.h>
#import "BasicPortalViewController.h"

@interface SlotCreateViewController : BasicPortalViewController
@property QueueEntity *queue;
@property SlotEntity *slot;
@property ProfileEntity *profileEntity;
@property TalonEntity *talon;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (weak, nonatomic) IBOutlet UITextField *dbField;
@property (weak, nonatomic) IBOutlet UITextField *pnameField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *snameField;
@property (weak, nonatomic) IBOutlet UITextField *enpField;
@property (weak, nonatomic) IBOutlet UITextField *snilsField;
@property (weak, nonatomic) IBOutlet UITextField *passportField;
@property (weak, nonatomic) IBOutlet UILabel *queueName;
@property (weak, nonatomic) IBOutlet UILabel *queueSpeciality;
@property (weak, nonatomic) IBOutlet UILabel *dateSlot;
@property (weak, nonatomic) IBOutlet UILabel *timeSlot;
@property (weak, nonatomic) IBOutlet UILabel *nameMo;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *documentView;
@property (weak, nonatomic) IBOutlet UIView *personalView;

@property (weak, nonatomic) IBOutlet UIView *polisView;
@property (weak, nonatomic) IBOutlet UIView *snameView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *pnameView;
@property (weak, nonatomic) IBOutlet UIView *dbView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *emailView;

@property (weak, nonatomic) IBOutlet UILabel *personalDataLink;

@end
