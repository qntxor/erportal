//
//  MoService.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "MoService.h"

@implementation MoService

- (void)loadData:(NSMutableArray *)dataItems tableView:(UITableView *)tableView activityIndicator:(UIActivityIndicatorView *)activityInicator {
    //[activityInicator startAnimating];
    [DisignContext showActivityIndicatorView:self.controller.view];
    AFHTTPRequestOperation *op = [[ServicePortal instance] getMosWithRegion:self.codeRegion];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null]){
            for ( NSDictionary *item in data )
            {
                MoEntity *model = [MoEntity new];
                model.idx = item[@"id"];
                model.name =item[@"name_short"];
                model.phone =item[@"phone"];
                model.address = [NSString stringWithFormat:@"%@ %@ %@",item[@"address_city"],item[@"address_street"],item[@"address_house"]];
                [dataItems addObject:model];
            }
        }
        [tableView reloadData];
        //[activityInicator stopAnimating];
        [DisignContext hideActivityIndicatorView:self.controller.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [PSIAlertHelper viewAlertAFHTTPRequestOperation:error];
        [DisignContext hideActivityIndicatorView:self.controller.view];
    }];
    [op start];
    //[[NSOperationQueue mainQueue] addOperation:op];
    //[op waitUntilFinished];
    
}

- (void)loadDataInLocalStore {
    AFHTTPRequestOperation *op = [[ServicePortal instance] getMos];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        NSMutableArray *dataItems = [NSMutableArray new];
        if(data && data != (id)[NSNull null] && data.count > 0){
            for ( NSDictionary *item in data )
            {
                MoEntity *model = [MoEntity new];
                model.idx = item[@"id"];
                model.name =item[@"name_short"];
                model.phone =item[@"phone"];
                model.address = [NSString stringWithFormat:@"%@ %@ %@",item[@"address_city"],item[@"address_street"],item[@"address_house"]];
                model.latitude = item[@"address_latitude"];
                model.longitude = item[@"address_longitude"];
                model.chief = item[@"chief"];
                model.fax = item[@"fax"];
                model.www = item[@"www"];
                model.district = item[@"district"];
                model.district_code = item[@"district_code"];
                
                [dataItems addObject:model];
            }
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
        
        // Load routes from local datastore on the main thread (blocking)
        [PFObject unpinAllObjectsWithName:[MoEntity parseClassName]];
        [PFObject pinAllInBackground:dataItems withName:[MoEntity parseClassName]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
    
}


@end
