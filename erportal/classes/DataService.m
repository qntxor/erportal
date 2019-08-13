//
//  DataService.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "DataService.h"

@implementation DataService

- (void) syncQuestions {
    QuestionService *service = [QuestionService new];
    [service loadDataInLocalStore:nil];
    //[service loadSubjectsInLocalStore];
}

- (void) syncMo {
    MoService *service = [MoService new];
    [service loadDataInLocalStore];
}

@end
