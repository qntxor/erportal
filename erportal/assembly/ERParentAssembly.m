//
//  ERParentAssembly.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "ERParentAssembly.h"
#import "Typhoon.h"
#import "ERErrorHandlerImpl.h"

@implementation ERParentAssembly

- (id<ERErrorHandler>)baseControllerErrorHandler
{
    return [TyphoonDefinition withClass:[ERErrorHandlerImpl class] configuration:^(TyphoonDefinition *definition)
            {
                [definition injectProperty:@selector(titleError) with:@"Внимание!"];
            }];
}

@end
