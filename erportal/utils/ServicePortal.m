//
//  ServicePortal.m
//  erportal
//


#import "ServicePortal.h"
#import "ProfileEntity.h"

@implementation ServicePortal

+(ServicePortal*)instance{
    
    static ServicePortal *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[ServicePortal alloc] init];
        sharedInstance.URLService = @"https://site.ru/api/";
        sharedInstance.token = @"token";
    });
    return sharedInstance;
}


- (NSMutableDictionary *)getDataPostURLWithString: (NSString *)bodyData withNameApi:(NSString *)apiName{
    NSMutableDictionary *outData;
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.URLService,apiName]]];
    
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    NSURLResponse *response;
    NSData *allData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:nil];
    
    if (allData) {
        NSError *error;
        outData = [NSJSONSerialization
                   JSONObjectWithData:allData
                   options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                   error:&error];
        if( error )
        {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__,error, [[NSString alloc] initWithData:allData encoding:NSUTF8StringEncoding]);
        }
    }else{
        NSLog(@"JSONObjectWithData error data = null");
    }
    
    return outData;
}



- (AFHTTPRequestOperation *)getOperationWithString: (NSString *)string{
    NSString *urlString = [self.URLService stringByAppendingString:[string stringByAppendingString:[NSString stringWithFormat:@"&token=%@",self.token]]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.securityPolicy.allowInvalidCertificates = YES;
    [op.securityPolicy  setValidatesDomainName:NO];
    return op;
}

- (AFHTTPRequestOperation *)getRegions{
    return [self getOperationWithString:@"get_regions?"];
}

- (AFHTTPRequestOperation *)getMos{
    return [self getOperationWithString:[NSString stringWithFormat:@"get_mos?"]];
}

- (AFHTTPRequestOperation *)getMosWithRegion:(NSString *)region{
    return [self getOperationWithString:[NSString stringWithFormat:@"get_mos?region=%@",region]];
}

- (AFHTTPRequestOperation *)getMosWithId:(NSString *)moId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@",@"mo?id=",moId]];
}

- (AFHTTPRequestOperation *)getServicesWithMoId:(NSString *)moId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@",@"services?mo_id=",moId]];
}

- (AFHTTPRequestOperation *)getServicesWithMoId:(NSString *)moId withDoctor:(NSString *)doctorId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@",@"services?mo_id=",moId,@"&mo_doctor=",doctorId]];
}

- (AFHTTPRequestOperation *)getServicesWithMoId:(NSString *)moId withSpeciality:(NSString *)specialityId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@",@"services?mo_id=",moId,@"&mo_spec=",specialityId]];
}

- (AFHTTPRequestOperation *)getSpecialityWithMoId:(NSString *)moId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@",@"get_specs?mo_id=",moId]];
}

- (AFHTTPRequestOperation *)getDoctorsWithMoId:(NSString *)moId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@",@"doctors?mo_id=",moId]];
}

- (AFHTTPRequestOperation *)getDoctorsWithMoId:(NSString *)moId withSpeciality:(NSString *)specialityId{
    return [self getOperationWithString:[NSString stringWithFormat:@"get_doctors?mo_id=%@&spec_id=%@",moId,specialityId]];
}

- (AFHTTPRequestOperation *)getQueueWithMoId:(NSString *)moId withService:(NSString *)serviceId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@",@"queues?mo_id=",moId,@"&service_id=",serviceId]];
}

- (AFHTTPRequestOperation *)getQueueWithMoId:(NSString *)moId withService:(NSString *)serviceId withDoctor:(NSString *)doctorId{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@",@"queues?mo_id=",moId,@"&service_id=",serviceId,@"&doctor_id=",doctorId]];
}

- (AFHTTPRequestOperation *)getFreeDaysForDoctor:(NSString *)moId withSpeciality:(NSString *)specialityId withDoctor:(NSString *)doctorId beginDate:(NSString *)beginDate endDate:(NSString *)endDate{
    return [self getOperationWithString:[NSString stringWithFormat:@"get_talons_statistics?mo_id=%@&doctor_id=%@&spec_id=%@&date_start=%@&date_finish=%@",moId,doctorId,specialityId,beginDate,endDate]];
}


- (AFHTTPRequestOperation *)getFreeWithQueue:(NSString *)queueId withService:(NSString *)serviceId beginDate:(NSString *)beginDate endDate:(NSString *)endDate{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"free?queue_id=",queueId,@"&service_id=",serviceId,@"&begin_date=",beginDate,@"&end_date=",endDate,@"&source=mob"]];
}

- (AFHTTPRequestOperation *)getSlotWithService:(NSString *)serviceId withQueue:(NSString *)queue_id withDate:(NSString *)date{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"slots?service_id=",serviceId,@"&queue_id=",queue_id,@"&date=",date,@"&source=mob"]];
}

- (AFHTTPRequestOperation *)getSlotWithDoctor:(NSString *)doctorId withSpeciality:(NSString *)specId withDate:(NSString *)date{
    return [self getOperationWithString:[NSString stringWithFormat:@"get_talons?doctor_id=%@&spec_id=%@&date_start=%@&date_finish=",doctorId,specId,date]];
}

- (AFHTTPRequestOperation *)createSlotWithService:(NSString *)serviceId withQueue:(NSString *)queue_id withDate:(NSString *)date withTime:(NSString *)time{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"create?service_id=",serviceId,@"&queue_id=",queue_id,@"&date=",date,@"&time=",time,@"&source=mob"]];
}

- (AFHTTPRequestOperation *)finishSlot:(NSString *)slotId withHash:(NSString *)hash withProfile:(ProfileEntity *)profile{
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"finish?slot_id=",slotId,@"&hash=",hash,
                 @"&snils=",[[profile.snils stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""],
                 @"&enp=",profile.enp,
                 @"&passport=",profile.passport,
                 @"&surname=",profile.sname,
                 @"&name=",profile.name,
                 @"&patronomic=",profile.pname,
                 @"&birthday=",profile.birthday,
                 @"&sex=",profile.sex,
                 @"&phone=",profile.phone,
                 @"&email=",profile.email,
                 @"&source=mob"]);
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"finish?slot_id=",slotId,@"&hash=",hash,
                                         @"&snils=",[[profile.snils stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                         @"&enp=",profile.enp,
                                         @"&passport=",[profile.passport stringByReplacingOccurrencesOfString:@" " withString:@""],
                                         @"&surname=",profile.sname,
                                         @"&name=",profile.name,
                                         @"&patronomic=",profile.pname,
                                         @"&birthday=",profile.birthday,
                                         @"&sex=",profile.sex,
                                         @"&phone=",profile.phone,
                                         @"&email=",profile.email,
                                         @"&source=mob"]];
}

- (AFHTTPRequestOperation *)createTalon:(NSString *)slotId withProfile:(ProfileEntity *)profile{

    return [self getOperationWithString:[NSString stringWithFormat:@"take_talon?talon_id=%@&policy=%@&last_name=%@&first_name=%@&patr_name=%@&date_birth=%@&phone=%@&email=%@",slotId,profile.enp,[profile.sname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[profile.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[profile.pname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],profile.birthday,profile.phone,profile.email]];
}

- (AFHTTPRequestOperation *)declineSlotWithId:(NSString *)slotId withDate:(NSString *)date withTime:(NSString *)time{
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@%@",@"decline?slotId=",slotId,@"&date=",date,@"&time=",time]);
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@",@"decline?slotId=",slotId,@"&date=",date,@"&time=",time]];
}

- (AFHTTPRequestOperation *)declineSlot:(NSString *)slotId withHash:(NSString *)hash{
    return [self getOperationWithString:[NSString stringWithFormat:@"back_talon?talon_id=%@&code_cancel=%@",slotId,hash]];
}

- (AFHTTPRequestOperation *)userTalons:(NSString *)usertoken{
    return [self getOperationWithString:[NSString stringWithFormat:@"user_talons?usertoken=%@",usertoken]];
}

- (AFHTTPRequestOperation *)statusSlotWithId:(NSString *)idx withHash:(NSString *)hash withDate:(NSString *)date withTime:(NSString *)time{
    return [self getOperationWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"status?id=",idx,@"&hash=",hash,@"&create_date=",date,@"&create_time=",time]];
}

- (AFHTTPRequestOperation *)statusSlotWithId:(NSString *)idx withHash:(NSString *)hash{
    return [self getOperationWithString:[NSString stringWithFormat:@"check_talon?talon_id=%@&code_cancel=%@",idx,hash]];
}

- (AFHTTPRequestOperation *)getQuestions:(NSString *)usertoken{
    return [self getOperationWithString:[NSString stringWithFormat:@"user_asks?usertoken=%@",usertoken]];
}

- (AFHTTPRequestOperation *)createQuestion:(NSString *)usertoken text:(NSString *)text subject:(NSString *)subject{
    return [self getOperationWithString:[NSString stringWithFormat:@"user_ask_new?usertoken=%@&subject=%@&message=%@",usertoken,[subject stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]];
}

- (AFHTTPRequestOperation *)subjects{
    return [self getOperationWithString:[NSString stringWithFormat:@"ask_subjects?"]];
}


- (AFHTTPRequestOperation *)auth:(NSString *)username password:(NSString *)password{
    return [self getOperationWithString:[NSString stringWithFormat:@"user_auth?username=%@&password=%@",[username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],password]];
}

- (AFHTTPRequestOperation *)userPeoples:(NSString *)usertoken{
    return [self getOperationWithString:[NSString stringWithFormat:@"user_peoples?usertoken=%@",usertoken]];
}

- (AFHTTPRequestOperation *)singup:(ProfileEntity *)profile username:(NSString *)username password:(NSString *)password{
    return [self getOperationWithString:[NSString stringWithFormat:@"user_register?username=%@&password=%@&email=%@&surname=%@&name=%@&patronymic=%@&date_birth=%@&policy=%@&gender=%@",[username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[profile.email stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[profile.sname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[profile.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[profile.pname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],profile.birthday,[profile.enp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],profile.sex]];
}

@end
