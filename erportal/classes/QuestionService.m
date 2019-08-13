//
//  QuestionService.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "QuestionService.h"

@implementation QuestionService

- (void)loadDataInLocalStore:(UITableView *)tableView {
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    AppEntity *app = [query getFirstObject];
    
    AFHTTPRequestOperation *op = [[ServicePortal instance] getQuestions:app.authToken];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        NSMutableArray *dataItems = [NSMutableArray new];
        if(data && data != (id)[NSNull null] && data.count > 0){
            for ( NSDictionary *item in data )
            {
                QuestionEntity *model = [QuestionEntity new];
                model.idx = item[@"id"];
                model.textQuestion = item[@"message"];
                model.textAnswer = item[@"answer"];
                model.subject = item[@"subject"];
                if (item[@"date_answer"] != [NSNull null]) {
                    model.dateAnswer = [Utils stringDateTimeToDate:item[@"date_answer"]];
                }
                model.dateQuestion = [Utils stringDateTimeToDate:item[@"date"]];
                [dataItems addObject:model];
            }
            [tableView reloadData];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
        
        // Load routes from local datastore on the main thread (blocking)
        [PFObject unpinAllObjectsWithName:[QuestionEntity parseClassName]];
        [PFObject pinAllInBackground:dataItems withName:[QuestionEntity parseClassName]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
    
}

-(void)loadSubjectsInLocalStore{
    
    AFHTTPRequestOperation *op = [[ServicePortal instance] subjects];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        NSMutableArray *dataItems = [NSMutableArray new];
        if(data && data != (id)[NSNull null] && data.count > 0){
            PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
            [query fromLocalDatastore];
            AppEntity *app = [query getFirstObject];
            app.questionSubjects = dataItems;
            [app pinInBackground];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

-(void)sendQuestion:(NSString *)text subject:(NSString *)subject{
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    AppEntity *app = [query getFirstObject];
    
    AFHTTPRequestOperation *op = [[ServicePortal instance] createQuestion:app.authToken text:text subject:subject];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            [self.controller.navigationController popViewControllerAnimated:YES];
            //[self.controller dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

- (NSArray *)dataItems{
    PFQuery *queryLocal = [PFQuery queryWithClassName:[QuestionEntity parseClassName]];
    [queryLocal fromLocalDatastore];
    return [queryLocal findObjects];
}

@end
