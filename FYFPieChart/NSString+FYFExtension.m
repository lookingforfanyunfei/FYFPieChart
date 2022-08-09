//
//  NSString+FYFExtension.m
//  FYFPieChart
//
//  Created by 范云飞 on 2022/8/9.
//

#import "NSString+FYFExtension.h"

@implementation NSString (FYFExtension)

@end

@implementation NSString (FYFSize)

- (CGSize)fyf_sizeWithFont:(UIFont *)font {
    return [self fyf_sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}
- (CGSize)fyf_sizeWithFontSize:(CGFloat)fontSize {
    return [self fyf_sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];;
}

- (CGSize)fyf_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    return [self fyf_boundingRectWithFont:font maxSize:maxSize].size;
}

- (CGRect)fyf_boundingRectWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSMutableDictionary * attrDict = [[NSMutableDictionary alloc] init];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    [attrDict setObject:font forKey:NSFontAttributeName];
    [attrDict setObject:style forKey:NSParagraphStyleAttributeName];
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrDict
                              context:nil];
}

- (CGFloat)fyf_heightWithWidth:(CGFloat)width font:(UIFont*)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace numberOfLines:(NSInteger)numberOfLines {
    if (numberOfLines < 0) {
        return 0;
    }
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    if (numberOfLines == 0) {
        CGSize orginalSize = [self fyf_boundingRectWithSize:size font:font lineSpace:lineSpace wordSpace:wordSpace];
        return ceil(orginalSize.height);
    }

    CGFloat maxHeight = font.lineHeight * numberOfLines + lineSpace * (numberOfLines - 1);

    CGSize orginalSize = [self fyf_boundingRectWithSize:size font:font lineSpace:lineSpace wordSpace:wordSpace];

    if (orginalSize.height >= maxHeight) {
        return ceil(maxHeight);
    } else {
        return ceil(orginalSize.height);
    }
}

- (CGSize)fyf_boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.hyphenationFactor = 1.0;
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    NSDictionary * dic = @{NSKernAttributeName:@(wordSpace)};
    [attributeString addAttributes:dic range:NSMakeRange(0, self.length)];;

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    return rect.size;
}

@end


@implementation NSString(KSRange)
- (NSRange)rangeOfStringNoCase:(NSString*)s {
    return  [self rangeOfString:s options:NSCaseInsensitiveSearch];
}

@end
