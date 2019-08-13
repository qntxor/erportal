//
//  QueueService.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "QueueService.h"

@implementation QueueService

- (void)loadDataDay:(NSMutableArray *)dataItems collectionView:(UICollectionView *)collectionView activityIndicator:(UIActivityIndicatorView *)activityInicator {
    [dataItems removeAllObjects];
    //[activityInicator startAnimating];
    AFHTTPRequestOperation *op = [[ServicePortal instance] getFreeDaysForDoctor:self.queue.moId withSpeciality:self.queue.specialityId withDoctor:self.queue.idx beginDate:[Utils dateToString:self.beginDate] endDate:[Utils dateToString:self.endDate]];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        NSDate *currentDate = [self.beginDate copy];
        if(data && data != (id)[NSNull null] && data.count > 0){
            for (int i=0; i < data.count; i++) {
                while (![[Utils dateToString:currentDate] isEqualToString:[[data objectAtIndex:i] valueForKey:@"date"]] && ![currentDate isEqual:self.endDate]) {
                    NSMutableDictionary *itemDay = [NSMutableDictionary new];
                    [itemDay setObject:[Utils dateToString:currentDate] forKey:@"date"];
                    [itemDay setObject:@"-" forKey:@"freeCount"];
                    currentDate = [Utils modifDateDay:currentDate withInterval:1];
                    [dataItems addObject:itemDay];
                }
                NSMutableDictionary *itemDay = [NSMutableDictionary new];
                [itemDay setObject:[[data objectAtIndex:i] valueForKey:@"date"] forKey:@"date"];
                [itemDay setObject:[[data objectAtIndex:i] valueForKey:@"free_count"] forKey:@"freeCount"];
                currentDate = [Utils modifDateDay:currentDate withInterval:1];
                [dataItems addObject:itemDay];
            }
            
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //
            //            });
            
        }
        [collectionView reloadData];
        //[activityInicator stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
    //[[NSOperationQueue mainQueue] addOperation:op];
    //[op waitUntilFinished];
    
}

- (void)loadDataTime:(NSMutableArray *)dataItems collectionView:(UICollectionView *)collectionView activityIndicator:(UIActivityIndicatorView *)activityInicator {
    [dataItems removeAllObjects];
    [collectionView reloadData];
    [DisignContext showActivityIndicatorView:self.controller.view];
    [activityInicator startAnimating];
    AFHTTPRequestOperation *op = [[ServicePortal instance] getSlotWithDoctor:self.queue.idx withSpeciality:self.queue.specialityId withDate:self.queue.startSlot];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            for ( NSDictionary *item in data )
            {
                SlotEntity *model = [SlotEntity new];
                model.idx = item[@"id"];
                model.status = item[@"status"];
                model.time = item[@"time"];
                model.date = item[@"date"];
                [dataItems addObject:model];
            }
            
        }else{
            //[self.controller presentViewController:[AlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
        [collectionView reloadData];
        [DisignContext hideActivityIndicatorView:self.controller.view];
        [activityInicator stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [DisignContext hideActivityIndicatorView:self.controller.view];
        [activityInicator stopAnimating];
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
    //[[NSOperationQueue mainQueue] addOperation:op];
    //[op waitUntilFinished];
    
}

@end
