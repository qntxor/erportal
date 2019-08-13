//
//  SlotService.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface SlotService : BaseService
@property QueueEntity *queue;
@property SlotEntity *slot;
@property ProfileEntity *profile;
@property TalonEntity *talon;

- (void) createTalon;
- (void) declineTalon:(TalonEntity *)talon nameSegueue:(NSString *)nameSgueue;
- (void) syncTalons;

@end
