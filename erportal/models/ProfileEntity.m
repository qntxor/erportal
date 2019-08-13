//
//  ProfileEntity.m
//  erportal
//


#import "ProfileEntity.h"
#import <CoreData/CoreData.h>

@implementation ProfileEntity

//@dynamic email;
//@dynamic error;
//@dynamic birthday;
//@dynamic passport;
//@dynamic sname;
//@dynamic phone;
//@dynamic fullName;
//@dynamic sex;
//@dynamic idx;
//@dynamic profile;
//@dynamic enp;
//@dynamic pname;
//@dynamic name;
//@dynamic snils;


+ (NSString *)parseClassName
{
    return @"ProfileEntity";
}

- (BOOL)validate{
    self.error = @"";
//    if ([self.snils isEqualToString:@"___-___-___ __"]) {
//        self.snils = @"";
//    }
//    if (self.snils.length == 0 && self.enp.length == 0 && self.passport.length == 0) {
//        self.error = @"Необходимо указать как минимум один документ из: единый номер полиса, серия и номер паспорта, СНИЛС";
//    }
    if (self.enp.length == 0) {
        self.error = @"Необходимо указать номер полиса";
    }
    if (self.sname.length == 0) {
        self.error = @"Необходимо указать фамилию";
    }
    if (self.name.length == 0) {
        self.error = @"Необходимо указать имя";
    }
    if (self.birthday.length == 0) {
        self.error = @"Необходимо указать дату рождения";
    }
    if (self.sex.length == 0 || [self.sex isEqualToString:@"0"]) {
        self.error = @"Необходимо указать пол";
    }
    if (self.phone.length == 0) {
        self.error = @"Необходимо указать телефон";
    }
    
    if (self.email.length == 0) {
        self.error = @"Необходимо указать email";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.birthday];
    if (!date) {
        self.error = @"Неверный формат даты рождения";
    }
    
    return self.error.length == 0;
}

- (void)initFromObject:(NSManagedObject *)object{
    self.sname = [object valueForKey:@"sname"]?[object valueForKey:@"sname"]:@"";
    self.name = [object valueForKey:@"name"]?[object valueForKey:@"name"]:@"";
    self.pname = [object valueForKey:@"pname"]?[object valueForKey:@"pname"]:@"";
    self.birthday = [object valueForKey:@"birthday"]?[object valueForKey:@"birthday"]:@"";
    self.snils = [object valueForKey:@"snils"]?[object valueForKey:@"snils"]:@"";
    self.enp = [object valueForKey:@"enp"]?[object valueForKey:@"enp"]:@"";
    self.passport = [object valueForKey:@"passport"]?[object valueForKey:@"passport"]:@"";
    self.sex = [object valueForKey:@"sex"]?[object valueForKey:@"sex"]:@"";
    self.phone = [object valueForKey:@"phone"]?[object valueForKey:@"phone"]:@"";
    self.email = [object valueForKey:@"email"]?[object valueForKey:@"email"]:@"";
    self.fullName = [NSString stringWithFormat:@"%@ %@ %@", self.sname,self.name,self.pname];
}

- (void)fillObject{
    [self.profile setValue:self.sname forKey:@"sname"];
    [self.profile setValue:self.name forKey:@"name"];
    [self.profile setValue:self.pname forKey:@"pname"];
    [self.profile setValue:self.birthday forKey:@"birthday"];
    [self.profile setValue:self.snils forKey:@"snils"];
    [self.profile setValue:self.enp forKey:@"enp"];
    [self.profile setValue:self.passport forKey:@"passport"];
    [self.profile setValue:self.sex forKey:@"sex"];
    [self.profile setValue:self.phone forKey:@"phone"];
    [self.profile setValue:self.email forKey:@"email"];
}

@end
