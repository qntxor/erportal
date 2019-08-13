//
//  ProfileEntity.h
//  erportal
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

@interface ProfileEntity : NSObject

+ (NSString *)parseClassName;

@property NSString *idx;
@property NSString *sname;
@property NSString *name;
@property NSString *pname;
@property NSString *birthday;
@property NSString *snils;
@property NSString *enp;
@property NSString *passport;
@property NSString *sex;
@property NSString *phone;
@property NSString *email;
@property NSString *error;
@property NSString *fullName;
@property NSManagedObject *profile;

- (BOOL)validate;
- (void)initFromObject:(NSManagedObject *)object;
- (void)fillObject;

@end
