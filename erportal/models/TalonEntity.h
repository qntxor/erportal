//
//  TalonEntity.h
//  erportal
//


#import <Foundation/Foundation.h>
#import "QueueEntity.h"
#import "SlotEntity.h"
#import <CoreData/CoreData.h>

@interface TalonEntity : NSObject
@property NSString *idx;
@property NSString *date;
@property NSString *hashTalon;
@property NSString *moId;
@property NSString *moName;
@property NSString *number;
@property NSString *paymenttype;
@property NSString *queueId;
@property NSString *queueName;
@property NSString *room;
@property NSString *serviceId;
@property NSString *serviceName;
@property NSString *speciality;
@property NSString *time;
@property NSString *url;
@property NSString *status;
@property NSString *sname;
@property NSString *name;
@property NSString *pname;
@property NSString *birthday;
@property NSManagedObject *object;
-(void)initFromQueue:(QueueEntity *)queue withSlot:(SlotEntity *)slot;
-(void)saveToDbWithContext:(NSManagedObjectContext *)context;
- (void) initFromObject:(NSManagedObject *)object;
@end
