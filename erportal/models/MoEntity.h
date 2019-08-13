//
//  MoEntity.h
//  erportal
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MoEntity : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *idx;
@property NSString *code;
@property NSString *name;
@property NSString *phone;
@property NSString *address;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *chief;
@property NSString *www;
@property NSString *fax;
@property NSString *district;
@property NSString *district_code;

@property (readonly) NSDate *creationDate;

@end
