//
//  PSIDateUtils.h
//  Pods
//
//  Created by Сергей Першиков on 31.10.16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSIDateUtils : NSObject
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
@end
