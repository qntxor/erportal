//
//  CityService.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "CityService.h"

@implementation CityService


- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator {
    //[activityInicator startAnimating];
    [DisignContext showActivityIndicatorView:self.controller.view];
    AFHTTPRequestOperation *op = [[ServicePortal instance] getRegions];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null]){
            for ( NSDictionary *item in data )
            {
                RegionEntity *model = [RegionEntity new];
                model.code = item[@"code"];
                model.value =item[@"value"];
                model.mo_count =item[@"mo_count"];
                [dataItems addObject:model];
            }
        }
        [tableView reloadData];
        //[activityInicator stopAnimating];
        [DisignContext hideActivityIndicatorView:self.controller.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [DisignContext hideActivityIndicatorView:self.controller.view];
        [PSIAlertHelper viewAlertAFHTTPRequestOperation:error];
    }];
    [op start];
    //[[NSOperationQueue mainQueue] addOperation:op];
    //[op waitUntilFinished];
    
}

@end
