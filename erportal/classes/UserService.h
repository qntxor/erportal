//
//  UserService.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface UserService : BaseService

-(void)singin:(NSString *)username password:(NSString *)password;
-(void)singup:(ProfileEntity *)profile usename:(NSString *)username password:(NSString *)password;

@end
