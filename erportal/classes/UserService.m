//
//  UserService.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "UserService.h"
#import "MenuViewController.h"

@implementation UserService

//Авторизируемся если нет данных в апп, то добавляем токен пользователя
- (void)singin:(NSString *)username password:(NSString *)password{
    AFHTTPRequestOperation *op = [[ServicePortal instance] auth:username password:password];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            NSDictionary *item = data[0];
            PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
            [query fromLocalDatastore];
            AppEntity *app;
            if ([query getFirstObject] == nil) {
                app = [AppEntity new];
            }else{
                app = [query getFirstObject];
            }
            app.authToken = [item objectForKey:@"token"];
            [app pinInBackground];
            DataService *dataService = [DataService new];
            [dataService syncQuestions];
            SlotService *slotService = [SlotService new];
            [slotService syncTalons];
            [self sincProfile];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

//Регистрация пользователя в системe
-(void)singup:(ProfileEntity *)profile usename:(NSString *)username password:(NSString *)password{
    AFHTTPRequestOperation *op = [[ServicePortal instance] singup:profile username:username password:password];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            NSDictionary *item = data[0];
            PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
            [query fromLocalDatastore];
            AppEntity *app;
            if ([query getFirstObject] == nil) {
                app = [AppEntity new];
            }else{
                app = [query getFirstObject];
            }
            app.authToken = [item objectForKey:@"token"];
            //Сохраняем токен и обновляем профиль в базе данных
            //TODO: подумать для переделки в парсе, смысл сохранять бд нет
            [app pinInBackground];
            
            DataService *dataService = [DataService new];
            [dataService syncQuestions];
            SlotService *slotService = [SlotService new];
            [slotService syncTalons];
            [self sincProfile];
            
            [self.controller dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

-(void)sincProfile{
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    AppEntity *app = [query getFirstObject];
    
    AFHTTPRequestOperation *op = [[ServicePortal instance] userPeoples:app.authToken];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            NSManagedObjectContext *context = [CoreDataContext shareManager].context;
            NSFetchRequest *fetchProfile = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
            NSMutableArray *profileItems = [[context executeFetchRequest:fetchProfile error:nil] mutableCopy];
            //Delete all object and insert new profiles, set first object active profile
            for (id profileItem in profileItems)
                [context deleteObject:profileItem];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            for (NSDictionary *item in data) {
                ProfileEntity *profile = [ProfileEntity new];
                
                profile.profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
                
                profile.sname = item[@"surname"];
                profile.name = item[@"name"];
                profile.pname = item[@"patronymic"];
                profile.birthday = item[@"date_birth"];
                profile.sex = item[@"gender"];
                profile.email = item[@"email"];
                profile.enp = item[@"policy"];
                if ([profile.enp isEqual:[NSNull null]]) {
                    profile.enp = @"";
                }
                if ([profile.email isEqual:[NSNull null]]) {
                    profile.email = @"";
                }
                if ([profile.sex isEqual:[NSNull null]]) {
                    profile.sex = @"1";
                }
                
                [profile fillObject];
                NSError *error = nil;
                if (![context save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
            }
            profileItems = [[context executeFetchRequest:fetchProfile error:nil] mutableCopy];
            NSManagedObject *profileActive = profileItems[0];
            [profileActive setValue:[NSNumber numberWithBool:YES] forKey:@"isactive"];
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }

            
            [self.controller dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.controller presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.controller presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
}

@end
