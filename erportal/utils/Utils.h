//
//  Utils.h
//  afisha
//
//  
//  Copyright (c) 2015 Routeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+ (NSString *)dateToString:(NSDate *)date;
+ (NSString *)dateToStringMonth:(NSDate *)date;
+ (NSDate *)stringToDate:(NSString *)date;
+ (NSString *)stringDateToStringWithoutYear:(NSString *)date;
+ (NSDate *)modifDateDay:(NSDate *)date withInterval:(int)interval;
+ (NSDate *)modifDateMonth:(NSDate *)date withInterval:(int)interval;
+ (NSString *)stringDateTimeToStringTime:(NSString *)date;
+ (NSDate *)stringDateTimeToDate:(NSString *)date;
+ (NSDate *)stringDateTimeMysqlToDate:(NSString *)date;
+ (NSString *)dateToStringTime:(NSDate *)date;
+ (NSMutableAttributedString *)dateToStringWithWeekDay:(NSDate *)date;
+ (NSArray*)findAllTextFieldsInView:(UIView*)view;
@end
