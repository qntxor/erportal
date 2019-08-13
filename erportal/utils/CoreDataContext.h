//
//  CoreDataContext.h
//  CommonService
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoEntity.h"
#import "SimpleEntity.h"
#import "QueueEntity.h"
#import "SlotEntity.h"
#import "ProfileEntity.h"
#import "TalonEntity.h"
#import "UserPersonal.h"
#import "RegionEntity.h"
#import "SpecializationEntity.h"
#import "DoctorEntity.h"
#import "QuestionEntity.h"
#import "AppEntity.h"

@interface CoreDataContext : NSObject
+(CoreDataContext *)shareManager;
@property NSManagedObjectContext *context;
@property NSString *token;
-(NSManagedObjectContext *)managedObjectContext;
-(NSString *)getToken;
@end
