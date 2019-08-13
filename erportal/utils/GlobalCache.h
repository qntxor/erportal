//
//  GlobalCache.h
//  CommonService
//
//  
//  Copyright (c) 2015 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalCache : NSObject
+(GlobalCache *)shareManager;
+(NSString *)getKey:(NSString *)organisationId withCatalogId:(NSString *)catalogId;
+(NSString *)getKeyActor:(NSString *)actorId;
+(NSString *)getKeyActorEntity:(NSString *)actorId;
@property(nonatomic,strong) NSCache* imageCacheCommon;
@property(nonatomic,strong) NSCache* imageCachePersonal;
@property(nonatomic,strong) NSCache* imageCache;
@property(nonatomic,strong) NSCache* citiesCache;
@property(nonatomic,strong) NSCache* orderСache;
@property(nonatomic,strong) NSCache* recordСache;

@end
