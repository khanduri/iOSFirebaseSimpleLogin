//
//  UIImage+Embross.m
//  Up100
//
//  Created by Prashant Khanduri on 6/1/14.
//  Original soure: http://stackoverflow.com/questions/8467141/ios-how-to-achieve-emboss-effect-for-the-text-on-uilabel
//
//

#import "UIImage+Embross.h"

@implementation UIImage (Embross)

+ (UIImage *)imageWithInteriorShadowAndString:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size
{
//    UIColor * interiorShadow = [UIColor colorWithWhite:.3 alpha:1];
//    UIColor * upwardShadow = [UIColor colorWithWhite:0 alpha:.15];
    UIColor * interiorShadow = [UIColor colorWithRed:0.9 green:0.5 blue:0.5 alpha:1.0];
    UIColor * upwardShadow = [UIColor colorWithRed:0.9 green:0.5 blue:0.5 alpha:1.0];
    return [UIImage imageWithInteriorShadow:interiorShadow upwardShadow:upwardShadow string:string font:font textColor:textColor size:size];
}

+ (UIImage *)imageWithInteriorShadow:(UIColor*) interiorShadow upwardShadow:(UIColor*)upwardShadow string:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size
{
    CGRect rect = { CGPointZero, size };
    UIImage *mask = [UIImage maskWithString:string font:font size:rect.size];
    UIImage *invertedMask = [UIImage invertedMaskWithMask:mask];
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale); {
        CGContextRef gc = UIGraphicsGetCurrentContext();
        // Clip to the mask that only allows drawing inside the string's image.
        CGContextClipToMask(gc, rect, mask.CGImage);
        // We apply the mask twice because we're going to draw through it twice.
        // Only applying it once would make the edges too sharp.
        CGContextClipToMask(gc, rect, mask.CGImage);
        mask = nil; // done with mask; let ARC free it
        
        // Draw the red text.
        [textColor setFill];
        CGContextFillRect(gc, rect);
        
        // Draw the interior shadow.
        CGContextSetShadowWithColor(gc, CGSizeZero, 1.6, interiorShadow.CGColor);
        [invertedMask drawAtPoint:CGPointZero];
        invertedMask = nil; // done with invertedMask; let ARC free it
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
//    return image;
    return [UIImage imageWithUpwardShadow:upwardShadow andImage:image];
}

+ (UIImage *)imageWithUpwardShadow:(UIColor *)upwardShadow andImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale); {
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, -1), 1, upwardShadow.CGColor);
        [image drawAtPoint:CGPointZero];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)maskWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size
{
    CGRect rect = { CGPointZero, size };
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef grayscale = CGColorSpaceCreateDeviceGray();
    CGContextRef gc = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, size.width * scale, grayscale, kCGImageAlphaOnly);
    CGContextScaleCTM(gc, scale, scale);
    CGColorSpaceRelease(grayscale);
    UIGraphicsPushContext(gc); {
        [[UIColor whiteColor] setFill];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attrsDictionary = @{
                                          NSFontAttributeName: font,
                                          NSParagraphStyleAttributeName: paragraphStyle
                                          };
        
        [string drawAtPoint:rect.origin withAttributes:attrsDictionary];
        
    } UIGraphicsPopContext();
    
    CGImageRef cgImage = CGBitmapContextCreateImage(gc);
    CGContextRelease(gc);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationDownMirrored];
    CGImageRelease(cgImage);
    
    return image;
}

+ (UIImage *)invertedMaskWithMask:(UIImage *)mask
{
    CGRect rect = { CGPointZero, mask.size };
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, mask.scale); {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
