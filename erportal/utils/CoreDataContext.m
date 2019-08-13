//
//  CoreDataContext.m
//  CommonService
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import "CoreDataContext.h"

@implementation CoreDataContext

+(CoreDataContext*)shareManager{
    
    static CoreDataContext *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[CoreDataContext alloc] init];
        sharedInstance.context = [sharedInstance managedObjectContext];
        //sharedInstance.token = [sharedInstance getToken];
    });
    return sharedInstance;
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSString *)getToken{
    NSFetchRequest *fetchProfile = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
    NSMutableArray *profileItems = [[self.context executeFetchRequest:fetchProfile error:nil] mutableCopy];
    if (profileItems.count > 0) {
        NSManagedObject *profile = [profileItems objectAtIndex:0];
        return [profile valueForKey:@"token"];
    }
    return nil;
}

@end
