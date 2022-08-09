//
//  NSString+FYFExtension.h
//  FYFPieChart
//
//  Created by 范云飞 on 2022/8/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FYFExtension)

@end

@interface NSString (FYFSize)

- (CGSize)fyf_sizeWithFont:(UIFont *)font;
- (CGSize)fyf_sizeWithFontSize:(CGFloat)fontSize;
- (CGSize)fyf_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGRect)fyf_boundingRectWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGFloat)fyf_heightWithWidth:(CGFloat)width font:(UIFont*)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace numberOfLines:(NSInteger)numberOfLines;

@end

@interface NSString (KSRange)

- (NSRange)rangeOfStringNoCase:(NSString*)s;

@end


NS_ASSUME_NONNULL_END
