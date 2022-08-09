//
//  GFPieChart.m
//  FYFPieChart
//
//  Created by 范云飞 on 2022/6/27.
//

#import "FYFPieChartView.h"
#import "FYFPieModel.h"
#import "NSString+FYFExtension.h"
#import "NSMutableAttributedString+FYFExtension.h"

@implementation FYFPieChartView

- (instancetype)init {
    self = [super init];
    if (self) {
        _roundWidth = 30;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _roundWidth = 30;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _roundWidth = 30;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)removeSublayers {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)draw {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.pieModels.count) {
        [self removeSublayers];
        return;
    }
    
    CGFloat minimum = MIN(rect.size.width, rect.size.height);
    /// 设置饼状图中心点
    CGPoint center =  CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    /// 设置外半径
    CGFloat outRadius = minimum/2 - 20;
    /// 设置内半径
    CGFloat innerRadius = outRadius - _roundWidth;
    
    /// 12点钟方向开始绘制
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:outRadius startAngle:-M_PI/2 endAngle:(M_PI/2) *3 clockwise:YES];
    
    CGFloat start = 0;
    CGFloat end = 0;
    
    CGFloat radianStart = -M_PI/2;
    CGFloat radianEnd = 0;
    
    /// 记录指引线起点
    NSMutableArray *lineStartPointArray = [NSMutableArray array];
    /// 记录每个圆弧中心弧度
    NSMutableArray *radianCenterArray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.pieModels.count; index ++) {
        FYFPieModel *model = self.pieModels[index];
        end = model.scale + start;
        radianEnd = radianStart + model.scale * M_PI * 2;
        
        /// 绘制圆弧
        CAShapeLayer *radianlayer = [self drawLayerWith:[UIColor clearColor] strokeColor:model.color strokeStart:start strokeEnd:end zPosition:2 lineWidth:_roundWidth path:path.CGPath];
        [self.layer addSublayer:radianlayer];
        
        /// 绘制圆弧之间的分割线
        if (self.pieModels.count > 1) {
            CAShapeLayer *linelayer = [self drawLayerWith:[UIColor clearColor] strokeColor:[UIColor whiteColor] strokeStart:start strokeEnd:start + 0.002 zPosition:2 lineWidth:_roundWidth path:path.CGPath];
            [self.layer addSublayer:linelayer];
        }
        
        /// 获取圆弧的中心角度
        CGFloat radianCenter = (radianStart + radianEnd) * 0.5;
        [radianCenterArray addObject:[NSNumber numberWithFloat:radianCenter]];
        
        /// 获取指引线的起点
        CGFloat lineStartX = self.frame.size.width * 0.5 + outRadius * cos(radianCenter);
        CGFloat lineStartY = self.frame.size.height * 0.5 + outRadius * sin(radianCenter);
        [lineStartPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(lineStartX, lineStartY)]];

        /// 更新下一次开始绘制的位置
        start = end;
        radianStart = radianEnd;
    }
    
    /// 根据指引线起点和中心弧度绘制指引线
    [self drawLineWithLineStartPointArray:lineStartPointArray radianCenterArray:radianCenterArray];
}

- (void)drawLineWithLineStartPointArray:(NSArray *)lineStartPointArray radianCenterArray:(NSArray *)radianCenterArray {
    CGFloat width  = self.frame.size.width *0.5;
    for (NSInteger index = 0; index < lineStartPointArray.count; index ++) {
        /// 每个圆弧中心点的角度
        CGFloat radianCenter = [radianCenterArray[index] floatValue];
        
        /// 绘制模型
        FYFPieModel *model = self.pieModels[index];
        
        /// 指引线起点
        NSValue *lineStartValue = lineStartPointArray[index];
        CGPoint lineStartPoint = lineStartValue.CGPointValue;
        CGFloat startX = lineStartPoint.x;
        CGFloat startY = lineStartPoint.y;
        
        /// 指引线折点
        CGFloat breakX = startX + 20*cos(radianCenter);
        CGFloat breakY = startY + 20*sin(radianCenter);
        
        /// 计算指引线终点
        CGFloat endX;
        CGFloat endY;
        
        ///计算折点到中心的垂直距离,添加20像素修正误差
        CGFloat breakMargin = fabs(width - breakX) + 20;
        
        /// 计算指引线长度
        CGFloat lineLength = width - breakMargin ;
        
        /// 文字高度和宽度
        CGFloat textWidth = 98;
        CGFloat textHeight = 54;
        CGFloat titleWidth = 0;
        CGFloat descWidth = 0;
        if (model.title.length) {
            titleWidth = [model.title fyf_sizeWithFont:[UIFont systemFontOfSize:14]].width;
        }
        if (model.desc.length) {
            descWidth = [model.desc fyf_sizeWithFont:[UIFont systemFontOfSize:12]].width;
        }
        /// 增加2个像素(指引线和text之间的间距)
        textWidth = MAX(titleWidth, descWidth) + 2;

        if (model.title.length) {
            textHeight = [model.title fyf_heightWithWidth:textWidth font:[UIFont systemFontOfSize:14] lineSpace:0 wordSpace:0 numberOfLines:0];
        }
        if (model.desc.length) {
            /// 加上2个像素(title和desc之间的间距)
            textHeight += [model.desc fyf_heightWithWidth:textWidth font:[UIFont systemFontOfSize:12] lineSpace:0 wordSpace:0 numberOfLines:0] + 2;
        }
        
        /// 文字的Point
        CGFloat textX;
        CGFloat textY;
        
        /// 文本段落属性
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        /// 文字靠右
        paragraph.alignment = NSTextAlignmentRight;
        /// 判断x位置，确定在指引线向左还是向右绘制
        /// 根据需要变更指引线的起始位置
        /// 变更文字和数字的位置
        if (startX <= width) {
            /// 在左边
            paragraph.alignment = NSTextAlignmentLeft;
            endX = 15 + textWidth;
            endY = breakY;
            
            textX = endX - textWidth;
        } else {
            /// 在右边
            endX = self.frame.size.width - 15 - textWidth;
            endY = breakY;
            
            textX = endX ;
        }
        textY = endY - 10;
        
        /// 文字超出当前视图顶部
        if (textY < 0) {
            textY = 0;
        }
        
        /// 文字超出当前视图底部
        if ((textY + textHeight) >= self.frame.size.height) {
            textY = endY - textHeight;
        }
        
        breakY = endY;
        
        /// 获取当前上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        /// 绘制路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(endX, endY)];
        [linePath addLineToPoint:CGPointMake(breakX, breakY)];
        [linePath addLineToPoint:CGPointMake(startX, startY)];
        CGContextSetLineWidth(ctx, 0.5);
        /// 设置颜色
        [[UIColor grayColor] set];
        /// 把绘制的内容添加到上下文当中
        CGContextAddPath(ctx, linePath.CGPath);
        /// 把上下文的内容显示到View上(渲染到View的layer)(stroke fill)
        CGContextStrokePath(ctx);
        
        /// 绘制文字描述
        NSString *text = [NSString stringWithFormat:@"%@\n%@",model.title, model.desc];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedString fyf_addColor:[UIColor blackColor] substring:model.title];
        [attributedString fyf_addFont:[UIFont systemFontOfSize:14] substring:model.title];
        
        [attributedString fyf_addColor:[UIColor grayColor] substring:model.desc];
        [attributedString fyf_addFont:[UIFont systemFontOfSize:12] substring:model.desc];
        
        [attributedString fyf_addAlignment:paragraph.alignment substring:text];
        
        [attributedString drawInRect:CGRectMake(textX, textY, textWidth, textHeight)];
    }
}


- (CAShapeLayer *)drawLayerWith:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor strokeStart:(CGFloat)strokeStart strokeEnd:(CGFloat)strokeEnd zPosition:(CGFloat)zPosition lineWidth:(CGFloat)lineWidth path:(CGPathRef)path {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = fillColor.CGColor;
    layer.strokeColor = strokeColor.CGColor;
    layer.strokeStart = strokeStart;
    layer.strokeEnd = strokeEnd;
    layer.zPosition = zPosition;
    layer.lineWidth = lineWidth;
    layer.path = path;
    return layer;
}


@end
