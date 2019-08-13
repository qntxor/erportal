//
//  DoctorService.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "DoctorService.h"

@implementation DoctorService

- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator {
    //[activityInicator startAnimating];
    [DisignContext showActivityIndicatorView:self.controller.view];
    AFHTTPRequestOperation *op = [[ServicePortal instance] getDoctorsWithMoId:self.moId withSpeciality:self.specialityId];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            for ( NSDictionary *item in data )
            {
                DoctorEntity *model = [DoctorEntity new];
                model.idx = item[@"id"];
                model.snils = item[@"snils"];
                model.surname = item[@"surname"];
                model.name = item[@"name"];
                model.patronymic = item[@"patronymic"];
                model.cabinet = item[@"cabinet"];
                model.fullName = [NSString stringWithFormat:@"%@ %@ %@",model.surname,model.name,model.patronymic];
                [dataItems addObject:model];
            }
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //
            //            });
            
        }
        [tableView reloadData];
        //[activityInicator stopAnimating];
        [DisignContext hideActivityIndicatorView:self.controller.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [DisignContext hideActivityIndicatorView:self.controller.view];
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
    //[[NSOperationQueue mainQueue] addOperation:op];
    //[op waitUntilFinished];
    
}

@end
