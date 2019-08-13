//
//  PSIDateUtils.m
//  Pods
//
//  Created by Сергей Першиков on 31.10.16.
//
//

#import "PSIDateUtils.h"
#define QXFORMAT_DATE "dd.MM.yyyy"
#define QXFORMAT_DATE_TIME "dd.MM.yyyy HH:mm"
#define QXLOCALE "ru_RU"

@implementation PSIDateUtils
+ (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@QXFORMAT_DATE];
    return [format stringFromDate:date];
}

+ (NSString *)dateToStringTime:(NSDate *)date{
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm"];
    return [format stringFromDate:date];
}

+ (NSString *)dateToStringMonth:(NSDate *)date{
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"MM"];
    return [format stringFromDate:date];
}

+ (NSDate *)stringToDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@QXFORMAT_DATE];
    return [dateFormatter dateFromString:date];
}

+ (NSDate *)stringDateTimeToDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@QXFORMAT_DATE_TIME];
    return [dateFormatter dateFromString:date];
}

+ (NSDate *)stringDateTimeMysqlToDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter dateFromString:date];
}

+ (NSString *)stringDateTimeToStringTime:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@QXFORMAT_DATE_TIME];
    NSDate *dateNew = [dateFormatter dateFromString:date];
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm"];
    return [format stringFromDate:dateNew];
}

+ (NSString *)stringDateToStringWithoutYear:(NSString *)date{
    NSDate *dateNew = [PSIDateUtils stringToDate:date];
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"dd.MM"];
    return [format stringFromDate:dateNew];
}

+ (NSMutableAttributedString *)dateToStringWithWeekDay:(NSDate *)date{
    NSDateFormatter *formatDate = [NSDateFormatter new];
    formatDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@QXLOCALE];
    [formatDate setDateFormat:@"dd MMMM yyyy"];
    NSString *textDate = [formatDate stringFromDate:date];
    NSDateFormatter *formatWeekday = [NSDateFormatter new];
    formatWeekday.locale = [[NSLocale alloc] initWithLocaleIdentifier:@QXLOCALE];
    [formatWeekday setDateFormat:@"EEEE"];
    NSString *textWeekday = [[formatWeekday stringFromDate:date] capitalizedString];
    
    NSString *text = [NSString stringWithFormat:@"%@ \n %@",textWeekday,textDate];
    NSRange rangeAll = [text rangeOfString:text];
    NSRange rangeWeekday = [text rangeOfString:textWeekday];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    //[string addAttribute:NSForegroundColorAttributeName value:OUR_APP_COLOR_TEXT_TITLE range:rangeAll];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"arial" size:14.0] range:rangeAll];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"arial" size:11.0] range:rangeWeekday];
    //[string addAttribute:NSForegroundColorAttributeName value:OUR_APP_COLOR_TEXT_COUNT range:rangeCount];
    
    return string;
}


+ (NSDate *)modifDateDay:(NSDate *)date withInterval:(int)interval{
    // set up date components
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:interval];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
}

+ (NSDate *)modifDateMonth:(NSDate *)date withInterval:(int)interval{
    // set up date components
    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:interval];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
}
@end
