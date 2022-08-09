//
//  FYFPieModel.h
//  FYFPieChart
//
//  Created by 范云飞 on 2022/6/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYFPieModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign)  CGFloat scale;
@property (nonatomic, strong)  UIColor *color;


@end

NS_ASSUME_NONNULL_END
