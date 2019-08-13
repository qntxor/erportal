//
//  MaskFormatter.h
//  MaskedTextFieldTest
//


#import <Foundation/Foundation.h>

@interface MaskFormatter : NSFormatter

@property (strong, nonatomic, readonly) NSString *mask;

- (MaskFormatter *) initWithMask:(NSString *)mask;
- (NSString *) stringForObjectValue:(NSString *)cleanString;
- (BOOL) getObjectValue:(NSString **)cleanString forString:(NSString *)string errorDescription:(NSString **)error;

@end
