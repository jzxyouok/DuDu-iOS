//
//  MyRouteVC.m
//  DuDu
//
//  Created by 教路浩 on 15/11/30.
//  Copyright © 2015年 i-chou. All rights reserved.
//

#import "MyRouteVC.h"
#import "RouteCell.h"
#import "RouteDetailVC.h"

@interface MyRouteVC ()

@end

@implementation MyRouteVC
{
    OrderStore *_orderStore;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self createTableView];
    [self fetchData];
}

- (void)initData
{
    _orderStore = [[OrderStore alloc] init];
}

- (void)fetchData
{
    if (![UICKeyChainStore stringForKey:KEY_STORE_ACCESS_TOKEN service:KEY_STORE_SERVICE]) {
        [ZBCToast showMessage:@"请先登录"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [[DuDuAPIClient sharedClient] GET:USER_ORDER_INFO parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [DuDuAPIClient parseJSONFrom:responseObject][@"info"];
//        NSDictionary *dic = [Utils testDicFrom:@"couponInfo"];
        NSArray *ing = [MTLJSONAdapter modelsOfClass:[OrderModel class]
                                                  fromJSONArray:dic[@"ing"]
                                                          error:nil];
        NSArray *history = [MTLJSONAdapter modelsOfClass:[OrderModel class]
                                           fromJSONArray:dic[@"history"]
                                                   error:nil];
        [OrderStore sharedOrderStore].ing = [ing mutableCopy];
        [OrderStore sharedOrderStore].history = [history mutableCopy];

        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)createTableView
{
    self.tableView.backgroundColor = COLORRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self setExtraCellLineHidden:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [OrderStore sharedOrderStore].history.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"routeCell";
    RouteCell *routeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!routeCell) {
        routeCell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:routeCell atIndexPath:indexPath];
    CGRect frame = [routeCell calculateFrame];
    return frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"routeCell";
    RouteCell *routeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!routeCell) {
        routeCell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        routeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self configureCell:routeCell atIndexPath:indexPath];
    return routeCell;
}

- (void)configureCell:(RouteCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.orderInfo = [OrderStore sharedOrderStore].history[indexPath.row];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteDetailVC *detailVC = [[RouteDetailVC alloc] init];
    detailVC.title = @"订单详情";
    detailVC.orderInfo = [OrderStore sharedOrderStore].history[indexPath.row];
    detailVC.isHistory = YES;
    detailVC.modelIndex = indexPath.row;
    [self.navigationController pushViewController:detailVC animated:YES];
}
 
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
