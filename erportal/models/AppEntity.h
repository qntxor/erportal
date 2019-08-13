//
//  AppEntity.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface AppEntity : PFObject <PFSubclassing>

@property NSString *authToken;
@property int indexActiveProfile;
@property NSMutableArray *questionSubjects;
+ (NSString *)parseClassName;

- (void)saveActiveProfile:(int) index;
- (void)syncIndexActiveProfile;
- (NSManagedObject *)activeProfileObject;

@end
