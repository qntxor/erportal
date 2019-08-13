//
//  QueueTimeViewController.m
//  erportal


#import "QueueTimeViewController.h"
#import "QueueTimeCollectionViewCell.h"
#import "QueueTimeViewController.h"
#import "SlotCreateViewController.h"

@interface QueueTimeViewController (){
    QueueService *service;
    NSMutableData *responseData;
}
@property NSMutableArray *dataItems;

@end

@implementation QueueTimeViewController

- (void)createSlot {
//    AFHTTPRequestOperation *op = [service createSlotWithService:self.queue.serviceId withQueue:self.queue.idx withDate:self.queue.startSlot withTime:self.queue.timeSlot];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *data = (NSDictionary *)responseObject;
//        if(data && data != (id)[NSNull null]){
//            self.slot.idx = [data valueForKey:@"id"];
//            self.slot.hashTalon = [data valueForKey:@"hash"];
//            [self performSegueWithIdentifier:@"QueueTimeToCreateSlot" sender:nil];
//        }
//        [self.activityInicator stopAnimating];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSString * errorStr = [[NSString alloc] initWithData:[NSData dataWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]] encoding:NSUTF8StringEncoding];
//        //handler(@{@"error":[NSString stringWithUTF8String:data.bytes]});
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка"
//                                                            message:errorStr
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [self.activityInicator stopAnimating];
//        [alertView show];
//    }];
//    [op start];
//    
}

//- (void)loadInitialData {
//    self.dataItems = [NSMutableArray new];
//    self.nameMo.text = self.queue.moName;
//    self.nameQueue.text = self.queue.name;
//    self.dayQueue.text = self.queue.startSlot;
//    AFHTTPRequestOperation *op = [service getSlotWithService:self.queue.serviceId withQueue:self.queue.idx withDate:self.queue.startSlot];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *data = [responseObject valueForKey:@"slot"];
//        if(data && data != (id)[NSNull null]){
//            self.dataItems = (NSMutableArray *)data;
//        }
//        [self.collectionView reloadData];
//        [self.activityInicator stopAnimating];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }];
//    [op start];
//    
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self loadInitialData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Назад";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    self.slot = [SlotEntity new];
    self.dataItems = [NSMutableArray new];
    service = [QueueService new];
    service.controller = self;
    service.queue = self.queue;
    self.currentDate = [Utils stringToDate:self.queue.startSlot];
    [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
    [service loadDataTime:self.dataItems collectionView:self.collectionView activityIndicator:self.activityInicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QueueTimeCollectionViewCell *cell = (QueueTimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    SlotEntity *dict = [self.dataItems objectAtIndex:indexPath.row];
    cell.timeLabel.text = dict.time;
    if ([dict.status isEqualToString:@"busy"]) {
        cell.backgroundColor = OUR_APP_COLOR_DAY_BUSY;
    }else if ([dict.status isEqualToString:@"free"]){
        cell.backgroundColor = OUR_APP_COLOR_DAY_FREE;
    }
    //cell.countLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"freeCount"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.activityInicator startAnimating];
    self.slot = [self.dataItems objectAtIndex:indexPath.row];
    self.queue.timeSlot = self.slot.time;
    self.slot.date = self.queue.startSlot;
    [self createSlot];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToTime"]) {
        SlotCreateViewController *nextController = (SlotCreateViewController *)segue.destinationViewController;
        [nextController setQueue:self.queue];
        [nextController setSlot:self.slot];
    }
    
}

- (IBAction)backWeekQueue:(id)sender {
    if (![[Utils dateToString:self.currentDate] isEqualToString:[Utils dateToString:[NSDate new]]]) {
        self.currentDate = [Utils modifDateDay:self.currentDate withInterval:-1];
        service.queue.startSlot = [Utils dateToString:self.currentDate];
        [service loadDataTime:self.dataItems collectionView:self.collectionView activityIndicator:self.activityInicator];
        [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
    }
    
}

- (IBAction)nextWeekQueue:(id)sender {
    self.currentDate = [Utils modifDateDay:self.currentDate withInterval:1];
    service.queue.startSlot = [Utils dateToString:self.currentDate];
    [service loadDataTime:self.dataItems collectionView:self.collectionView activityIndicator:self.activityInicator];
    [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
}

@end
