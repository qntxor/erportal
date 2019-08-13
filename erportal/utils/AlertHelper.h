//
//  AlertHelper.h
//
//  Created by Сергей Першиков on 08.01.16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertHelper : NSObject
+(UIAlertController *)viewAlertAFHTTPRequestOperation:(NSError *)error;
+(UIAlertController *)viewAlertBasicMessage:(NSString *)error;
+ (void)showAlertViewWithError:(NSError *)error;
@end
