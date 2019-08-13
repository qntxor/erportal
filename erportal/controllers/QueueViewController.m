//
//  QueueViewController.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "QueueViewController.h"
#import "QueueDayCollectionViewCell.h"
#import "QueueTimeCollectionViewCell.h"
#import "QueueTimeViewController.h"
#import "SlotCreateViewController.h"

@interface QueueViewController (){
    QueueService *service;
    NSMutableData *responseData;
}
@property NSMutableArray *dataItemsDays;
@property NSMutableArray *dataItemsTime;
@property NSDate *beginDate;
@property NSDate *endDate;
@property int intervalQueue;
@property UIView *subviewEmptyCollectionView;
@end

@implementation QueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.activityIndicatorChangeDay = [UIActivityIndicatorView new];
    [self.activityIndicatorChangeDay stopAnimating];
    
    self.intervalQueue = 30;
    if (!self.beginDate) {
        self.beginDate = [NSDate new];
        self.endDate = [Utils modifDateDay:self.beginDate withInterval:self.intervalQueue];
        self.queue.startSlot = [Utils dateToString:self.beginDate];
    }
    self.currentDate = [NSDate new];

    self.navigationItem.title = [NSString stringWithFormat:@"%@", @"Время приема"];
    
    //Получаем модели
    MoEntity *mo = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_MO];
    SpecializationEntity *spec = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_SPECIALIZATION];
    DoctorEntity *doctor = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_DOCTOR];
    
    //Cоздаем очередь
    self.queue = [QueueEntity new];
    self.queue.idx = doctor.idx;
    self.queue.name = doctor.fullName;
    self.queue.specialityId = spec.idx;
    self.queue.speciality = spec.name;
    self.queue.room = doctor.cabinet;
    self.queue.moId = mo.idx;
    self.queue.moName = mo.name;
    self.queue.startSlot = [Utils dateToString:self.currentDate];
    
    //inizialization
    self.slot = [SlotEntity new];
    self.dataItemsDays = [NSMutableArray new];
    self.dataItemsTime = [NSMutableArray new];
    service = [QueueService new];
    service.controller = self;
    service.beginDate = self.beginDate;
    service.endDate = self.endDate;
    service.queue = self.queue;
    [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
    [service loadDataDay:self.dataItemsDays collectionView:self.daysCollectionView activityIndicator:self.activityInicator];
    [service loadDataTime:self.dataItemsTime collectionView:self.timeCollectionView activityIndicator:self.activityInicator];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.daysCollectionView){
        return self.dataItemsDays.count;
    }
    //Если нет талонов в этот день то показываем картинку
    if (self.dataItemsTime.count == 0) {
        //Create subview
        [self.subviewEmptyCollectionView removeFromSuperview];
        self.subviewEmptyCollectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, 300)];
        //Add
        UIImageView *thumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(collectionView.frame.size.width/2-40, 50, 80, 80)];
        thumbnailImage.image = [UIImage imageNamed:@"non-favorite-icon"];
        [self.subviewEmptyCollectionView addSubview:thumbnailImage];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(collectionView.frame.size.width/2-130, 150 , 260 ,62)];
        lblTitle.numberOfLines = 0;
        [lblTitle setFont:[UIFont systemFontOfSize:14]];
        [lblTitle setTextColor:OUR_APP_COLOR_TEXT_TITLE];
        lblTitle.text = @"К сожалению, на этот день нет свободных талонов. \n Выберите другой день.";
        lblTitle.textAlignment = NSTextAlignmentCenter;
        [self.subviewEmptyCollectionView addSubview:lblTitle];
        
        [collectionView addSubview:self.subviewEmptyCollectionView];
        //Bring to front so that it does not get hidden by cells
        //[collectionView bringSubviewToFront:self.subviewEmptyCollectionView];
    }else{
        [self.subviewEmptyCollectionView removeFromSuperview];
    }
    return self.dataItemsTime.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.daysCollectionView){
        QueueDayCollectionViewCell *cell = (QueueDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
        
        NSDictionary *dict = [self.dataItemsDays objectAtIndex:indexPath.row];
        
        NSDate *dateSlot = [Utils stringToDate:[dict valueForKey:@"date"]];
        
        NSDateFormatter *formatWeekday = [NSDateFormatter new];
        formatWeekday.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
        [formatWeekday setDateFormat:@"EE"];
        NSString *textWeekday = [[[formatWeekday stringFromDate:dateSlot] capitalizedString] substringToIndex:2];
        cell.weekdayLabel.text = textWeekday;
        
        NSDateFormatter *formatDay = [NSDateFormatter new];
        [formatDay setDateFormat:@"dd"];
        cell.dateLabel.text = [formatDay stringFromDate:dateSlot];
        
        NSString *countSlot = [NSString stringWithFormat:@"%@",[dict valueForKey:@"freeCount"]];
        
        NSLog(@"%@",cell.dateLabel.text);

        [cell layoutIfNeeded];
        
        if ([countSlot isEqualToString:@"0"] || [countSlot isEqualToString:@"-"]) {
            cell.dateImageView.image = [UIImage imageNamed:@"non-pass"];
        }else{
            cell.dateImageView.image = [UIImage imageNamed:@"free-date-green"];
        }
        if ([[Utils dateToString:self.currentDate] isEqualToString:[dict valueForKey:@"date"]]) {
            [DisignContext setRoundedView:cell.dateImageView border:4.0 color:OUR_APP_COLOR_TEXT_COUNT];
        }else{
            cell.dateImageView.layer.borderWidth = 0;
        }
        
        return cell;
    }
    QueueTimeCollectionViewCell *cell = (QueueTimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell" forIndexPath:indexPath];
    
    SlotEntity *dict = [self.dataItemsTime objectAtIndex:indexPath.row];
    cell.timeLabel.text = dict.time;
    if ([dict.status isEqualToString:@"busy"]) {
        cell.backgroundColor = OUR_APP_COLOR_DAY_BUSY;
    }else if ([dict.status isEqualToString:@"free"]){
        cell.backgroundColor = OUR_APP_COLOR_DAY_FREE;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.daysCollectionView){
        if (!self.activityIndicatorChangeDay.isAnimating) {
            service.queue.startSlot = [[self.dataItemsDays objectAtIndex:indexPath.row] valueForKey:@"date"];
            self.currentDate = [Utils stringToDate:service.queue.startSlot];
            //NSMutableDictionary *itemDay = [self.dataItemsDays objectAtIndex:indexPath.row];
            //NSString *value = [NSString stringWithFormat:@"%@",[itemDay valueForKey:@"freeCount"]];
            [self.daysCollectionView reloadData];
            [service loadDataTime:self.dataItemsTime collectionView:self.timeCollectionView activityIndicator:self.activityIndicatorChangeDay];
            [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
        }
    }else{
        self.slot = [self.dataItemsTime objectAtIndex:indexPath.row];
        self.queue.timeSlot = self.slot.time;
        if ([self.slot.status isEqualToString:@"free"]){
            //self.slot.date = self.queue.startSlot;
            SlotCreateViewController * vc = (SlotCreateViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"SlotCreateViewController"];
            [vc setQueue:self.queue];
            [vc setSlot:self.slot];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self presentViewController:[PSIAlertHelper viewAlertBasicMessage:@"К сожалению, в это время нет приема."] animated:true completion:nil];
        }

    }

    
}

- (IBAction)backWeekQueue:(id)sender {
    if (![[Utils dateToString:self.currentDate] isEqualToString:[Utils dateToString:[NSDate new]]] && !self.activityIndicatorChangeDay.isAnimating) {
        self.currentDate = [Utils modifDateDay:self.currentDate withInterval:-1];
        [self.daysCollectionView reloadData];
        service.queue.startSlot = [Utils dateToString:self.currentDate];
        [service loadDataTime:self.dataItemsTime collectionView:self.timeCollectionView activityIndicator:self.activityIndicatorChangeDay];
        [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
    }
    
}

- (IBAction)nextWeekQueue:(id)sender {
    if (!self.activityIndicatorChangeDay.isAnimating) {
        self.currentDate = [Utils modifDateDay:self.currentDate withInterval:1];
        service.queue.startSlot = [Utils dateToString:self.currentDate];
        [self.daysCollectionView reloadData];
        [service loadDataTime:self.dataItemsTime collectionView:self.timeCollectionView activityIndicator:self.activityIndicatorChangeDay];
        [self.intervalDate setAttributedText:[Utils dateToStringWithWeekDay:self.currentDate]];
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToCreateSlot"]) {
        SlotCreateViewController *nextController = (SlotCreateViewController *)segue.destinationViewController;
        [nextController setQueue:self.queue];
        [nextController setSlot:self.slot];
    }
    
    
}


@end
