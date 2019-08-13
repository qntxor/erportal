//
//  UserPersonal.h
//  StavropolTranstur
//
//   
//  Copyright © 2016 Routeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ngrvalidator/NGRValidator.h"

@interface UserPersonal : NSObject <NGRMessaging>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sname;
@property (strong, nonatomic) NSString *pname;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *typeDocument;
@property (strong, nonatomic) NSString *serialDocument;
@property (strong, nonatomic) NSString *numberDocument;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;

@property (nonatomic, strong) NSArray *documentTypes;

- (NSError *)validateWithDocument;
- (NSError *)validate;

@end
