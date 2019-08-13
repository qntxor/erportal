//
//  ERErrorHandler.h
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//  Обработчик ошибок приложения
//

@class ERErrorHandler;

@protocol ERErrorHandler <NSObject>

- (void) errorHandler:(NSError *)error;

@end
