//
//  ERParentAssembly.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"
#import "ERErrorHandler.h"


@interface ERParentAssembly : TyphoonAssembly


- (id<ERErrorHandler>) baseControllerErrorHandler;

@end
