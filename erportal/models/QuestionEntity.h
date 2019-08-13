//
//  QuestionEntity.h
//  erportal
//
// 
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface QuestionEntity : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *idx;
@property NSDate *dateQuestion;
@property NSDate *dateAnswer;
@property NSString *textQuestion;
@property NSString *textAnswer;
@property NSString *subject;
@property (readonly) NSDate *creationDate;


@end
