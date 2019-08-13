//
//  QuestionEntity.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "QuestionEntity.h"
#import <Parse/Parse.h>

@implementation QuestionEntity

@dynamic idx;
@dynamic dateAnswer;
@dynamic dateQuestion;
@dynamic textAnswer;
@dynamic textQuestion;
@dynamic creationDate;
@dynamic subject;

+ (NSString *)parseClassName
{
    return @"QuestionEntity";
}

@end
