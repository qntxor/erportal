//
//  SlotFinishViewController.m
//  erportal


#import "SlotFinishViewController.h"

@interface SlotFinishViewController (){
    SlotService *service;
    NSMutableData *responseData;
}
@property NSManagedObjectContext *context;
@end

@implementation SlotFinishViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [DisignContext setBorderTopView:self.dateView width:7 image:[UIImage imageNamed:@"pass-green-small"]];
//    [DisignContext setBorderBottomView:self.commonView width:7 image:[UIImage imageNamed:@"pass-grey-small"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:1 green:0.176 blue:0.333 alpha:1];
    self.nameMo.text = self.talon.moName;
    self.numberSlot.text = self.talon.number;
    self.dateSlot.text = self.talon.date;
    self.timeSlot.text = self.talon.time;
    self.nameQueue.text = self.talon.queueName;
    self.speciality.text = self.talon.speciality;
    self.room.text = self.talon.room;
    if (self.room.text.length == 0) {
        self.room.text = @"не указан";
    }
    self.patient.text = [NSString stringWithFormat:@"%@ %@ %@",self.talon.sname, self.talon.name, self.talon.pname];
    self.statusSlot.text = @"";
    [self generateQrcode:self.talon.url];
    service = [SlotService new];
    service.controller = self;
    self.context = [CoreDataContext shareManager].context;
    
    //Делаем дизайн
    self.dateView.backgroundColor = OUR_APP_COLOR_TALON_FREE;
    self.commonView.backgroundColor = OUR_APP_COLOR_TALON_LIGHT;
    

    
    AFHTTPRequestOperation *op = [[ServicePortal instance] statusSlotWithId:self.talon.idx withHash:self.talon.hashTalon];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            self.talon.status = [[data objectAtIndex:0] valueForKey:@"state"];
            if (![self.talon.status isEqualToString:@"pending"] && ![self.talon.status isEqualToString:@"accepted"]) {
                self.cancelButton.hidden = YES;
            }else{
                self.cancelButton.hidden = NO;
            }
        }else{
            [self presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelSlot:(UIButton *)sender {
    
    [service declineTalon:self.talon nameSegueue:@"ToMenu"];
}

- (void) generateQrcode:(NSString *)code{
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:code
                                  format:kBarcodeFormatQRCode
                                   width:300
                                  height:300
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        [self.barCode setImage:[UIImage imageWithCGImage:image]];
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"%@",errorMessage);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
