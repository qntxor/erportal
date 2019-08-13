//
//  GlobalCache.m
//  CommonService
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import "GlobalCache.h"

@implementation GlobalCache
+(GlobalCache*)shareManager{
    
    static GlobalCache *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[GlobalCache alloc] init];
        
    });
    return sharedInstance;
}

+(NSString *)getKey:(NSString *)organisationId withCatalogId:(NSString *)catalogId{
    return [NSString stringWithFormat:@"%@_%@",organisationId,catalogId];
}

+(NSString *)getKeyActor:(NSString *)actorId{
    return [NSString stringWithFormat:@"actor_%@",actorId];
}

+(NSString *)getKeyActorEntity:(NSString *)actorId{
    return [NSString stringWithFormat:@"actor_details_%@",actorId];
}



@end
