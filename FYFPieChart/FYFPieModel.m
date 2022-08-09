//
//  FYFPieModel.m
//  FYFPieChart
//
//  Created by 范云飞 on 2022/6/27.
//

#import "FYFPieModel.h"

@interface FYFPieModel ()

@end

@implementation FYFPieModel

- (instancetype)initWithScale:(CGFloat)scale desc:(NSString *)desc color:(UIColor *)color {
    self = [super init];
    if (self) {
        _scale = scale;
        _desc = desc;
        _color = color;
    }
    return self;
}

@end
