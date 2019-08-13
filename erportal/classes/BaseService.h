//
//  BaseService.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataContext.h"

@interface BaseService : NSObject

@property UIViewController *controller;

-(id)initWithController:(UIViewController *)controller;

@end
