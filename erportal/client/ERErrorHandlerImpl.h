//
//  ERErrorHandlerImpl.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ERErrorHandler.h"

@interface ERErrorHandlerImpl : NSObject <ERErrorHandler>

@property(nonatomic, strong) NSString* titleError;

@end
