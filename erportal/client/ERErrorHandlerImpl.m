//
//  ERErrorHandlerImpl.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "ERErrorHandlerImpl.h"

@implementation ERErrorHandlerImpl

#pragma protocol
- (void) errorHandler:(NSError *)error{
    NSLog(@"%@",error);
}
@end
