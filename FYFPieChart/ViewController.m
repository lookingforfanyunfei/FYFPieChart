//
//  ViewController.m
//  FYFPieChart
//
//  Created by 范云飞 on 2022/8/9.
//

#import "ViewController.h"
#import "FYFPieChartView.h"
#import "FYFPieModel.h"

@interface ViewController ()

@property (nonatomic, strong) FYFPieChartView *pieChartView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    FYFPieModel *model1 = [[FYFPieModel alloc] init];
    model1.scale = 0.4;
    model1.title = @"息差收入";
    model1.desc = @"2890.28万元\n23.12%";
    model1.color = [UIColor redColor];
    
    
    FYFPieModel *model2 = [[FYFPieModel alloc] init];
    model2.scale = 0.3;
    model2.title = @"手续费减免收入";
    model2.desc = @"2890.28万元\n23.12%";
    model2.color = [UIColor orangeColor];
    
    
    FYFPieModel *model3 = [[FYFPieModel alloc] init];
    model3.scale = 0.3;
    model3.title = @"留存手续费";
    model3.desc = @"2890.28万元\n23.12%";
    model3.color = [UIColor blueColor];
    
    [self.view addSubview:self.pieChartView];
    self.pieChartView.pieModels = @[model1, model2, model3];
    [self.pieChartView draw];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 80)/2, CGRectGetMaxY(self.pieChartView.frame) + 50, 80, 30);
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"reDraw" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reDraw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)reDraw {
    [self.pieChartView draw];
}

- (FYFPieChartView *)pieChartView {
    if (!_pieChartView) {
        _pieChartView = [[FYFPieChartView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 168)];
    }
    return _pieChartView;
}

@end
