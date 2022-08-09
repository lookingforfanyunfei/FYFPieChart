//
//  FYFPieChartView.h
//  FYFPieChart
//
//  Created by 范云飞 on 2022/6/27.
//

#import <UIKit/UIKit.h>

@class FYFPieModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYFPieChartView : UIView

/// 绘制
- (void)draw;
/// 圆环宽度，默认30
@property (nonatomic, assign) CGFloat roundWidth;
/// 数据源
@property (nonatomic, strong) NSArray<FYFPieModel *>*models;

@end

NS_ASSUME_NONNULL_END
