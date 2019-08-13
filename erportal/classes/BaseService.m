//
//  BaseService.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

-(id)initWithController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        self.controller = controller;
    }
    return self;
}

@end
