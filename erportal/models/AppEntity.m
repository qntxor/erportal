//
//  AppEntity.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "AppEntity.h"

@implementation AppEntity

@dynamic authToken;
@dynamic questionSubjects;
@dynamic indexActiveProfile;

-(id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

+ (NSString *)parseClassName
{
    return @"AppEntity";
}

- (void)saveActiveProfile:(int)index {
    self.indexActiveProfile = index;
    [self pinInBackground];
    NSManagedObjectContext *context = [CoreDataContext shareManager].context;
    NSMutableArray *profileItems = [NSMutableArray new];
    NSFetchRequest *fetchProfile = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
    profileItems = [[context executeFetchRequest:fetchProfile error:nil] mutableCopy];
    
    for (NSManagedObject *object in profileItems) {
        if ([profileItems indexOfObject:object] == index) {
            [object setValue:[NSNumber numberWithBool:YES] forKey:@"isactive"];
        } else {
            [object setValue:[NSNumber numberWithBool:NO] forKey:@"isactive"];
        }
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

//Устанавливаем активный индекс из профиля и сам профиль
- (void)syncIndexActiveProfile{
    NSManagedObjectContext *context = [CoreDataContext shareManager].context;
    NSMutableArray *profileItems = [NSMutableArray new];
    profileItems = [[context executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"Profile"] error:nil] mutableCopy];
    
    for (NSManagedObject *object in profileItems) {
        if ([[object valueForKey:@"isactive"] boolValue]) {
            self.indexActiveProfile = [profileItems indexOfObject:object];
            [self pinInBackground];
        }
    }
}

- (NSManagedObject *)activeProfileObject{
    NSManagedObjectContext *context = [CoreDataContext shareManager].context;
    NSMutableArray *profileItems = [NSMutableArray new];
    profileItems = [[context executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"Profile"] error:nil] mutableCopy];
    for (NSManagedObject *object in profileItems) {
        NSLog(@"%c",[[object valueForKey:@"isactive"] boolValue]);
        if ([[object valueForKey:@"isactive"] boolValue]) {
            return object;
        }
    }
    return nil;
}
@end
