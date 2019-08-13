//
//  SlotService.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "SlotService.h"
#import "SlotFinishViewController.h"
#import "SlotCreateViewController.h"

@implementation SlotService


- (void) createTalon{
    SlotCreateViewController *controller = (SlotCreateViewController *)self.controller;
    [controller.activityInicator startAnimating];
    AFHTTPRequestOperation *op = [[ServicePortal instance] createTalon:self.slot.idx withProfile:self.profile];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [controller.activityInicator stopAnimating];
        NSLog(@"%@",responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            self.slot.number = [[data objectAtIndex:0] valueForKey:@"id"];
            self.slot.url = [[data objectAtIndex:0] valueForKey:@"url"];
            self.slot.idx = [[data objectAtIndex:0] valueForKey:@"id"];
            self.slot.hashTalon = [[data objectAtIndex:0] valueForKey:@"code_cancel"];
            if (self.profile.profile == nil) {
                self.profile.profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:[CoreDataContext shareManager].context];
            }
            [self.profile fillObject];
            
            //Save Talon
            self.talon = [TalonEntity new];
            [self.talon initFromQueue:self.queue withSlot:self.slot];
            self.talon.sname = [self.profile.sname copy];
            self.talon.name = [self.profile.name copy];
            self.talon.pname = [self.profile.pname copy];
            self.talon.birthday = [self.profile.birthday copy];
            [self.talon saveToDbWithContext:[CoreDataContext shareManager].context];
            
            NSError *error = nil;
            if (![[CoreDataContext shareManager].context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            SlotFinishViewController * vc = (SlotFinishViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"SlotFinishViewController"];
            [vc setTalon:self.talon];
            [self.controller.navigationController pushViewController:vc animated:YES];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [controller.activityInicator stopAnimating];
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

- (void) checkStatus{
    AFHTTPRequestOperation *op = [[ServicePortal instance] statusSlotWithId:self.slot.idx withHash:self.slot.hashTalon];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            self.slot.status = [[data objectAtIndex:0] valueForKey:@"state"];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

- (void) declineTalon:(TalonEntity *)talon nameSegueue:(NSString *)nameSgueue{
    AFHTTPRequestOperation *op = [[ServicePortal instance] declineSlot:talon.idx withHash:talon.hashTalon];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            NSString *status = [[data objectAtIndex:0] valueForKey:@"value"];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"ok"]) {
                
                [[CoreDataContext shareManager].context deleteObject:talon.object];
                NSError *error = nil;
                
                if (![[CoreDataContext shareManager].context save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                    return;
                }
                [[GlobalCache shareManager].recordСache removeObjectForKey:@CACHE_KEY_RECORD_REGION];
                [[GlobalCache shareManager].recordСache removeObjectForKey:@CACHE_KEY_RECORD_MO];
                [[GlobalCache shareManager].recordСache removeObjectForKey:@CACHE_KEY_RECORD_SPECIALIZATION];
                [[GlobalCache shareManager].recordСache removeObjectForKey:@CACHE_KEY_RECORD_DOCTOR];
                [self.controller performSegueWithIdentifier:nameSgueue sender:nil];
            }
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

- (void) syncTalons{
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    AppEntity *app = [query getFirstObject];
    
    AFHTTPRequestOperation *op = [[ServicePortal instance] userTalons:app.authToken];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            for (id talon in [[[CoreDataContext shareManager].context executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"Talons"] error:nil] mutableCopy])
                [[CoreDataContext shareManager].context deleteObject:talon];
            
            for ( NSDictionary *item in data )
            {
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Talons" inManagedObjectContext:[CoreDataContext shareManager].context];
                [object setValue:item[@"id"] forKey:@"idx"];
                [object setValue:item[@"date"] forKey:@"date"];
                if ([item[@"cancel_code"] isEqual:[NSNull null]]) {
                   [object setValue:@"" forKey:@"hashTalon"];
                }else{
                   [object setValue:item[@"cancel_code"] forKey:@"hashTalon"];
                }
                [object setValue:item[@"number"] forKey:@"number"];
                [object setValue:item[@"time"] forKey:@"time"];
                [object setValue:item[@"url"] forKey:@"url"];
                [object setValue:item[@"mo_id"] forKey:@"moId"];
                [object setValue:item[@"mo_name"] forKey:@"moName"];
                [object setValue:item[@"payment_type"] forKey:@"paymenttype"];
                [object setValue:item[@"doc_id"] forKey:@"queueId"];
                [object setValue:[NSString stringWithFormat:@"%@ %@ %@",item[@"doc_surname"],item[@"doc_name"],item[@"doc_patronymic"]] forKey:@"queueName"];
                [object setValue:item[@"room"] forKey:@"room"];
                [object setValue:item[@"doc_id"] forKey:@"serviceId"];
                [object setValue:[NSString stringWithFormat:@"%@ %@ %@",item[@"doc_surname"],item[@"doc_name"],item[@"doc_patronymic"]] forKey:@"serviceName"];
                [object setValue:item[@"doc_spec"] forKey:@"speciality"];
                [object setValue:item[@"date_birth"] forKey:@"birthday"];
                [object setValue:item[@"surname"] forKey:@"sname"];
                [object setValue:item[@"name"] forKey:@"name"];
                [object setValue:item[@"patronymic"] forKey:@"pname"];
                NSError *error = nil;
                // Save the object to persistent store
                if (![[CoreDataContext shareManager].context save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
            }
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

@end
