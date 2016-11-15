//
//  TableViewController.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//
//屏幕尺寸
#define kDeviceWidth [[UIScreen mainScreen]bounds].size.width
#define kDeviceHight [[UIScreen mainScreen]bounds].size.height
#import "TableViewController.h"
#import "CategoryModel.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "TableViewHeaderView.h"

static NSString * const LeftCellID = @"LeftCellID";
static NSString * const RightCellID = @"RightCellID";

@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>{

    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (strong, nonatomic) NSMutableArray<CALayer *> *redLayers;
@property (nonatomic, strong) NSMutableArray *LeftDataArrM;
@property (nonatomic, strong) NSMutableArray *RightDataArrM;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@end

@implementation TableViewController
- (NSMutableArray<CALayer *> *)redLayers {
    if (!_redLayers) {
        _redLayers = [NSMutableArray array];
    }
    return _redLayers;
}
-(NSMutableArray *)LeftDataArrM{
    if (!_LeftDataArrM) {
        _LeftDataArrM = [NSMutableArray array];
    }
    return _LeftDataArrM ;
}
-(NSMutableArray *)RightDataArrM{
    if (!_RightDataArrM) {
        _RightDataArrM = [NSMutableArray array];
    }
    return _RightDataArrM;
}
- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, kDeviceHight)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 55;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:LeftCellID];
    }
    
    return _leftTableView;
}

- (UITableView *)rightTableView {
    
    if (!_rightTableView) {
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 64, kDeviceWidth - 80, kDeviceHight)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:RightCellID];
    }
    
    return _rightTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _selectIndex = 0;
    _isScrollDown = YES;
    
    //加载数据
    [self loadData];
    
    //创建表格
    [self createTable];
    
    
}
- (void)initCHLayerFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint {
    //UIView主要是对显示内容的管理而 CALayer 主要侧重显示内容的绘制。
    CALayer *chLayer = [[CALayer alloc] init];
    [self.redLayers addObject:chLayer];
    //起始位置.大小
    chLayer.frame = CGRectMake(startPoint.x, startPoint.y, 15, 15);
    //设置一个圆
    chLayer.cornerRadius = CGRectGetWidth(chLayer.frame)/2.f;
    //颜色为红色
    chLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:chLayer];
    //关键帧动画
    CAKeyframeAnimation *CHAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    //创建路径(是基于路径)
    CGMutablePathRef path = CGPathCreateMutable();
    //起点开始绘制
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    //结束
    CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, startPoint.y, endPoint.x, endPoint.y);
    
    CHAnimation.path = path;
    //设置是否动画完成后,动画效果从设置的layer上移除。默认为YES
    CHAnimation.removedOnCompletion = NO;
    //设置类型,默认是删除
    CHAnimation.fillMode = kCAFillModeBoth;
    //时间
    CHAnimation.duration = 0.5;
    //要设置代理
    CHAnimation.delegate = self;
    //最后添加到CALayer上
    [chLayer addAnimation:CHAnimation forKey:nil];
    
  
    
    
}
-(void)loadData{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"meituan.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
//    NSLog(@"%@",dict);
    
    NSArray * arr = dict[@"data"][@"food_spu_tags"];
    
    for (NSDictionary *dicts in arr) {
        CategoryModel *model = [CategoryModel objectWithDictionary:dicts];
        [self.LeftDataArrM addObject:model];
        
        NSMutableArray * d = [NSMutableArray array];
        
        for (NSDictionary *ds in model.spus) {
            [d addObject:ds];
            
        }
        [self.RightDataArrM addObject:d];
    }
    

}
-(void)createTable{
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.leftTableView==tableView) ? 1 : self.LeftDataArrM.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  (self.leftTableView == tableView) ? self.LeftDataArrM.count : [self.RightDataArrM[section]count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.leftTableView == tableView) {
        
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftCellID forIndexPath:indexPath];
        CategoryModel *model = self.LeftDataArrM[indexPath.row];
        cell.name.text = model.name;
        
        return cell;
    }else {
        
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RightCellID forIndexPath:indexPath];
        FoodModel *model = self.RightDataArrM[indexPath.section][indexPath.row];
        cell.model = model;
        [cell btnBlockReturn:^(NSInteger x) {
            x =  indexPath.row;
            NSLog(@"%ld",x);
            FoodModel *model = self.RightDataArrM[indexPath.section][x];
            NSLog(@"%@",model.foodId);
        }];
        [cell setPlusTapHandle:^(CGPoint position) {
            
            CGPoint startPoint = [self.view convertPoint:position fromView:self.rightTableView];
            CGPoint endPoint = [self.view convertPoint:CGPointMake(0, kDeviceHight) fromView:self.view];
            [self initCHLayerFromPoint:startPoint toPoint:endPoint];
            //model add to array
            
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (self.rightTableView == tableView) ? 20 : 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    TableViewHeaderView * view = [[TableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    CategoryModel * model = self.LeftDataArrM[section];
    view.name.text = model.name;
    
    return (self.rightTableView == tableView) ? view: nil;

}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging) {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_leftTableView != tableView) return;
    
    _selectIndex = indexPath.row;
    [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    static CGFloat lastOffsetY = 0;
    UITableView *tableView = (UITableView *)scrollView;
    if (_rightTableView == tableView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
