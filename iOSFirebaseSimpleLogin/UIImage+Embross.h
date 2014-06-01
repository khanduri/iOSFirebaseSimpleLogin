//
//  UIImage+Embross.h
//  Up100
//
//  Created by Prashant Khanduri on 6/1/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Embross)

+ (UIImage *)imageWithInteriorShadowAndString:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size;
+ (UIImage *)imageWithInteriorShadow:(UIColor*) interiorShadow upwardShadow:(UIColor*)upwardShadow string:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size;

@end
