//
//  TalonEntity.m
//  erportal
//

#import "TalonEntity.h"

@implementation TalonEntity

- (void)initFromQueue:(QueueEntity *)queue withSlot:(SlotEntity *)slot{
    self.idx = [[NSString alloc] initWithFormat:@"%@",slot.idx];
    self.date = slot.date;
    self.hashTalon = slot.hashTalon;
    self.number = slot.number;
    self.time = slot.time;
    self.url = slot.url;
    self.moId = [[NSString alloc] initWithFormat:@"%@",queue.moId];
    self.moName = queue.moName;
    self.paymenttype = queue.paymenttype;
    self.queueId = [[NSString alloc] initWithFormat:@"%@",queue.idx];
    self.queueName = queue.name;
    self.room = [[NSString alloc] initWithFormat:@"%@",queue.room];
    self.serviceId = [[NSString alloc] initWithFormat:@"%@",queue.specialityId];
    self.serviceName = queue.speciality;
    self.speciality = queue.speciality;
    self.status = slot.status;
    
}

- (void) initFromObject:(NSManagedObject *)object{
    self.idx = [object valueForKey:@"idx"];
    self.date = [object valueForKey:@"date"];
    self.hashTalon = [object valueForKey:@"hashTalon"];
    self.number = [object valueForKey:@"number"];
    self.time = [object valueForKey:@"time"];
    self.url = [object valueForKey:@"url"];
    self.moId = [object valueForKey:@"moId"];
    self.moName = [object valueForKey:@"moName"];
    self.paymenttype = [object valueForKey:@"paymenttype"];
    self.queueId = [object valueForKey:@"queueId"];
    self.queueName = [object valueForKey:@"queueName"];
    self.room = [object valueForKey:@"room"];
    self.serviceId = [object valueForKey:@"serviceId"];
    self.serviceName = [object valueForKey:@"serviceName"];
    self.speciality = [object valueForKey:@"speciality"];
    self.status = [object valueForKey:@"status"];
    self.birthday = [object valueForKey:@"birthday"];
    self.sname = [object valueForKey:@"sname"];
    self.name = [object valueForKey:@"name"];
    self.pname = [object valueForKey:@"pname"];
    self.object = object;
}

- (void)saveToDbWithContext:(NSManagedObjectContext *)context{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Talons" inManagedObjectContext:context];
    [object setValue:self.idx forKey:@"idx"];
    [object setValue:self.date forKey:@"date"];
    [object setValue:self.hashTalon forKey:@"hashTalon"];
    [object setValue:self.number forKey:@"number"];
    [object setValue:self.time forKey:@"time"];
    [object setValue:self.url forKey:@"url"];
    [object setValue:self.moId forKey:@"moId"];
    [object setValue:self.moName forKey:@"moName"];
    [object setValue:self.paymenttype forKey:@"paymenttype"];
    [object setValue:self.queueId forKey:@"queueId"];
    [object setValue:self.queueName forKey:@"queueName"];
    [object setValue:self.room forKey:@"room"];
    [object setValue:self.serviceId forKey:@"serviceId"];
    [object setValue:self.serviceName forKey:@"serviceName"];
    [object setValue:self.speciality forKey:@"speciality"];
    [object setValue:self.birthday forKey:@"birthday"];
    [object setValue:self.sname forKey:@"sname"];
    [object setValue:self.name forKey:@"name"];
    [object setValue:self.pname forKey:@"pname"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    self.object = object;
}



@end
