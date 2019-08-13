//
//  MoAnnotation.h
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MoAnnotation : MKPointAnnotation
@property(nonatomic, strong) MoEntity *mo;
@end
