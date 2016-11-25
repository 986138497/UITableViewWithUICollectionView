//
//  ViewController.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *dataArrM;
@property (nonatomic, strong) UITableView *rightTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _rightTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    [self.view addSubview:_rightTableView];
    
    _dataArrM = @[@"UITableView - UITableView联动",
                  @"UICollectionView - UITableView联动",
                  ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"RootCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
   // cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _dataArrM[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        TableViewController *tableVC = [[TableViewController alloc] init];
        tableVC.title = @"两Table联动";
        [self.navigationController pushViewController:tableVC animated:YES];
    }else if(indexPath.row == 1) {
        
        CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
        collectionVC.title = @"Table与Collection联动";
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
