//
//  UserPersonal.m
//  StavropolTranstur
//
//   
//  Copyright © 2016 Routeam. All rights reserved.
//

#import "UserPersonal.h"

@implementation UserPersonal

- (instancetype)init {
    self = [super init];
    if (self) {
        //self.documentTypes = [NSArray new];
    }
    return self;
}

- (NSError *)validateWithDocument {
    NSError *error = nil;
    [NGRValidator validateModel:self error:&error delegate:self rules:^NSArray *{
        return @[
                 NGRValidate(@"name").required().minLength(2).syntax(NGRSyntaxName).localizedName(@"Имя").msgNil(@"обязательно.").msgTooShort(@"слишком короткое.").msgWrongSyntax(NGRSyntaxName,@"должно содержать только буквы."),
                NGRValidate(@"sname").required().minLength(2).syntax(NGRSyntaxName).localizedName(@"Фамилия").msgNil(@"обязательно.").msgTooShort(@"слишком короткое.").msgWrongSyntax(NGRSyntaxName,@"должно содержать только буквы."),
                NGRValidate(@"pname").required().minLength(2).syntax(NGRSyntaxName).localizedName(@"Отчество").msgNil(@"обязательно.").msgTooShort(@"слишком короткое.").msgWrongSyntax(NGRSyntaxName,@"должно содержать только буквы."),
                    NGRValidate(@"sex").required().localizedName(@"Пол").msgNil(@"обязателен."),
                    NGRValidate(@"birthday").required().earlierThan([NSDate new]).localizedName(@"Дата рождения").msgNil(@"обязательна."),
                    NGRValidate(@"typeDocument").required().localizedName(@"Тип документа").msgNil(@"обязателен."),
                    NGRValidate(@"serialDocument").required().localizedName(@"Серия документа").msgNil(@"обязательна."),
                    NGRValidate(@"numberDocument").required().localizedName(@"Номер документа").msgNil(@"обязательна."),
                    NGRValidate(@"email").required().syntax(NGRSyntaxEmail).localizedName(@"Почта").msgNil(@"обязательна.").msgWrongSyntax(NGRSyntaxEmail,@"неверна."),
                    NGRValidate(@"phone").required().regex(@"\\([0-9]{3}\\)\\-[0-9]{3}\\-[0-9]{2}\\-[0-9]{2}", NSRegularExpressionCaseInsensitive).localizedName(@"Телефон").msgNil(@"обязателен.").msgWrongRegex(@"неправильного формата")];
    }];
    if (error == nil) {
        error = [self validateMaskDocument];
    }    
    return error;
}

- (NSError *)validate {
    NSError *error = nil;
    [NGRValidator validateModel:self error:&error delegate:self rules:^NSArray *{
        return @[
                 NGRValidate(@"name").required().minLength(2).syntax(NGRSyntaxName).localizedName(@"Имя").msgNil(@"обязательно.").msgTooShort(@"слишком короткое.").msgWrongSyntax(NGRSyntaxName,@"должно содержать только буквы."),
                 NGRValidate(@"sname").required().minLength(2).syntax(NGRSyntaxName).localizedName(@"Фамилия").msgNil(@"обязательно.").msgTooShort(@"слишком короткое.").msgWrongSyntax(NGRSyntaxName,@"должно содержать только буквы."),
                 NGRValidate(@"pname").required().minLength(2).syntax(NGRSyntaxName).localizedName(@"Отчество").msgNil(@"обязательно.").msgTooShort(@"слишком короткое.").msgWrongSyntax(NGRSyntaxName,@"должно содержать только буквы."),
                 NGRValidate(@"sex").required().localizedName(@"Пол").msgNil(@"обязателен."),
                 NGRValidate(@"birthday").required().earlierThan([NSDate new]).localizedName(@"Дата рождения").msgNil(@"обязательна."),
                 NGRValidate(@"email").required().syntax(NGRSyntaxEmail).localizedName(@"Почта").msgNil(@"обязательна.").msgWrongSyntax(NGRSyntaxEmail,@"неверна."),
                 NGRValidate(@"phone").required().regex(@"\\([0-9]{3}\\)\\-[0-9]{3}\\-[0-9]{2}\\-[0-9]{2}", NSRegularExpressionCaseInsensitive).localizedName(@"Телефон").msgNil(@"обязателен.").msgWrongRegex(@"неправильного формата")];
    }];
    return error;
}

- (NSError *)validateMaskDocument{
    NSError *error = nil;
    int typeDocument = (int)[self.documentTypes indexOfObject:self.typeDocument];
    NSString *sDocPattern;
    NSString *nDocPattern;
    NSString *errSMsg;
    NSString *errNMsg;
    switch (typeDocument) {
            // Паспорт гражданина Российской Федерации (99 99 999999)
        case 0:
        {
            sDocPattern = @"^\\d{4}$";
            nDocPattern = @"^\\d{6}$";
            errSMsg = @"4 цифры";
            errNMsg = @"6 цифр";
        }
            break;
            // Паспорт моряка (ББ 0999999)
        case 1 :
        {
            sDocPattern = @"^[А-ЯЁ]{2}$";
            nDocPattern = @"^\\d{6,7}$";
            errSMsg = @"две буквы кириллицы в верхнем регистре";
            errNMsg = @"от 6 до 7 цифр";
        }
            break;
            // Общегражданский заграничный паспорт гражданина Российской Федерации (99 9999999)
        case 2 :
        {
            sDocPattern = @"^\\d{2}$";
            nDocPattern = @"^\\d{7}$";
            errSMsg = @"2 цифры";
            errNMsg = @"7 цифр";
        }
            break;
            // Паспорт иностранного гражданина (SSSSSSSSSS...)
        case 3 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Свидетельство о рождении (RББ 999999) "I", "V", "X", "L", "С"
        case 4 :
            sDocPattern = @"^[IVXLC]{1,5}[А-ЯЁ]{2}$";
            nDocPattern = @"^\\d{6}$";
            errSMsg = @"Римские цифры в латинском регистре, 2 буквы кириллицы в верхнем регистре";
            errNMsg = @"6 цифр";
            break;
            // Удостоверение личности военнослужащего (ББ 0999999)
        case 5 :
            sDocPattern = @"^[А-ЯЁ]{2}$";
            nDocPattern = @"^\\d{6,7}$";
            errSMsg = @"две буквы кириллицы в верхнем регистре";
            errNMsg = @"от 6 до 7 цифр";
            break;
            // Удостоверение личности лица без гражданства (SSSSSSSSSS...)
        case 6 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Временное удостоверение личности, выдаваемое органами внутренних дел (SSSSSSSSSS...)
        case 7 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Военный билет военнослужащего срочной службы (ББ 0999999)
        case 8 :
            sDocPattern = @"^[А-ЯЁ]{2}$/u";
            nDocPattern = @"^\\d{7}$";
            errSMsg = @"две буквы кириллицы в верхнем регистре";
            errNMsg = @"7 цифр";
            break;
            // Вид на жительство иностранного гражданина или лица без гражданства (SSSSSSSSSS...)
        case 9 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Справка об освобождении из мест лишения свободы (SSSSSSSSSS...)
        case 10 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Паспорт гражданина СССР (RББ 999999) "I", "V", "X", "L", "С"
        case 11 :
            sDocPattern = @"^[IVXLC]{1,5}[А-ЯЁ]{2}$";
            nDocPattern = @"^\\d{6}$";
            errSMsg = @"Римские цифры в латинском регистре, 2 буквы кириллицы в верхнем регистре";
            errNMsg = @"6 цифр";
            break;
            // Паспорт дипломатический (99 9999999)
        case 12 :
            sDocPattern = @"^\\d{2}$";
            nDocPattern = @"^\\d{7}$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Паспорт служебный (кроме паспорта моряка и дипломатического) (SSSSSSSSSS...)
        case 13 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Свидетельство о возвращении из стран СНГ (SSSSSSSSSS...)
        case 14 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Справка об утере паспорта (SSSSSSSSSS...)
        case 15 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            // Удостоверение депутата (SSSSSSSSSS...)
        case 16 :
            sDocPattern = @"^.*$";
            nDocPattern = @"^.*$";
            errSMsg = @"";
            errNMsg = @"";
            break;
            
        default:
            break;
    }
    NSRange rs = [self.serialDocument rangeOfString:sDocPattern options:NSRegularExpressionSearch];
    NSRange rn = [self.numberDocument rangeOfString:nDocPattern options:NSRegularExpressionSearch];
    if (rs.location == NSNotFound || rn.location == NSNotFound ) {
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        [userInfo setObject:[NSString stringWithFormat:@"Документ: серия %@, номер %@",errSMsg, errNMsg] forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"user" code:200 userInfo:userInfo];
    }
    return error;
}

#pragma mark - NGRMessaging

- (NSDictionary *)validationErrorMessagesByPropertyKey {
    
    return @{@"name3" : @{MSGNil : @"Имя обязательно.",
                         MSGTooShort : @"Имя слишком короткое.",
                         MSGNotName : @"Имя должно содержать только буквы." }};
}

@end
