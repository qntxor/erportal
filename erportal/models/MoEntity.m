//
//  MoEntity.m
//  erportal
//


#import "MoEntity.h"

@implementation MoEntity
@dynamic phone;
@dynamic idx;
@dynamic creationDate;
@dynamic name;
@dynamic address;
@dynamic code;
@dynamic chief;
@dynamic www;
@dynamic fax;
@dynamic latitude;
@dynamic longitude;
@dynamic district;
@dynamic district_code;

+ (NSString *)parseClassName
{
return @"MoEntity";
}

@end
