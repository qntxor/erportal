//
//  ERApplicationAssembly.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "ERApplicationAssembly.h"
#import "NanoFrame.h"

@implementation ERApplicationAssembly


- (ERStartUpConfigurator *)defaultConfiguration
{
    return [TyphoonDefinition withClass:[ERStartUpConfigurator class] configuration:^(TyphoonDefinition *definition)
            {
                [definition injectProperty:@selector(backgroundColor) with:[UIColor colorWithHexRGB:0x641d23]];
            }];
    return nil;
}

@end
