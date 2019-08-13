//
//  ServicePortal.h
//  erportal
//


#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "CityService.h"
#import "MoService.h"
#import "SpecialityService.h"
#import "DoctorService.h"
#import "QueueService.h"
#import "SlotService.h"
#import "QuestionService.h"
#import "DataService.h"
#import "UserService.h"

@interface ServicePortal : NSObject
+(ServicePortal*)instance;
- (AFHTTPRequestOperation *)getRegions;
- (AFHTTPRequestOperation *)getMos;
- (AFHTTPRequestOperation *)getMosWithId:(NSString *)moId;
- (AFHTTPRequestOperation *)getMosWithRegion:(NSString *)region;
- (AFHTTPRequestOperation *)getServicesWithMoId:(NSString *)moId;
- (AFHTTPRequestOperation *)getSpecialityWithMoId:(NSString *)moId;
- (AFHTTPRequestOperation *)getDoctorsWithMoId:(NSString *)moId withSpeciality:(NSString *)specialityId;
- (AFHTTPRequestOperation *)getDoctorsWithMoId:(NSString *)moId;
- (AFHTTPRequestOperation *)getServicesWithMoId:(NSString *)moId withDoctor:(NSString *)doctorId;
- (AFHTTPRequestOperation *)getServicesWithMoId:(NSString *)moId withSpeciality:(NSString *)specialityId;
- (AFHTTPRequestOperation *)getFreeDaysForDoctor:(NSString *)moId withSpeciality:(NSString *)specialityId withDoctor:(NSString *)doctorId beginDate:(NSString *)beginDate endDate:(NSString *)endDate;
- (AFHTTPRequestOperation *)getQueueWithMoId:(NSString *)moId withService:(NSString *)serviceId;
- (AFHTTPRequestOperation *)getQueueWithMoId:(NSString *)moId withService:(NSString *)serviceId withDoctor:(NSString *)doctorId;
- (AFHTTPRequestOperation *)getFreeWithQueue:(NSString *)queueId withService:(NSString *)serviceId beginDate:(NSString *)beginDate endDate:(NSString *)endDate;
- (AFHTTPRequestOperation *)getSlotWithService:(NSString *)serviceId withQueue:(NSString *)queue_id withDate:(NSString *)date;
- (AFHTTPRequestOperation *)createSlotWithService:(NSString *)serviceId withQueue:(NSString *)queue_id withDate:(NSString *)date withTime:(NSString *)time;
- (AFHTTPRequestOperation *)getSlotWithDoctor:(NSString *)doctorId withSpeciality:(NSString *)specId withDate:(NSString *)date;
- (AFHTTPRequestOperation *)finishSlot:(NSString *)slotId withHash:(NSString *)hash withProfile:(ProfileEntity *)profile;
- (AFHTTPRequestOperation *)createTalon:(NSString *)slotId withProfile:(ProfileEntity *)profile;
- (AFHTTPRequestOperation *)statusSlotWithId:(NSString *)idx withHash:(NSString *)hash withDate:(NSString *)date withTime:(NSString *)time;
- (AFHTTPRequestOperation *)userTalons:(NSString *)usertoken;
- (AFHTTPRequestOperation *)statusSlotWithId:(NSString *)idx withHash:(NSString *)hash;
- (AFHTTPRequestOperation *)declineSlotWithId:(NSString *)slotId withDate:(NSString *)date withTime:(NSString *)time;
- (AFHTTPRequestOperation *)declineSlot:(NSString *)slotId withHash:(NSString *)hash;
- (AFHTTPRequestOperation *)subjects;
- (AFHTTPRequestOperation *)getQuestions:(NSString *)usertoken;
- (AFHTTPRequestOperation *)createQuestion:(NSString *)usertoken text:(NSString *)text subject:(NSString *)subject;
- (AFHTTPRequestOperation *)auth:(NSString *)username password:(NSString *)password;
- (AFHTTPRequestOperation *)userPeoples:(NSString *)usertoken;
- (AFHTTPRequestOperation *)singup:(ProfileEntity *)profile username:(NSString *)username password:(NSString *)password;
@property NSString *URLService;
@property NSString *token;
@property (nonatomic, retain) NSMutableData *responseData;
@end
