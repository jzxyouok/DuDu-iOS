//
//  MenuTableViewController.m
//  DuDu
//
//  Created by i-chou on 11/17/15.
//  Copyright © 2015 i-chou. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuCell.h"
#import "MyRouteVC.h"
#import "MyWalletVC.h"
#import "RecommendVC.h"
#import "SettingsVC.h"
#import "CouponVC.h"

#define PADDING 10

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController
{
    UIImageView *_avator;
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
}

+ (instancetype)sharedMenuTableViewController
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedMenuTableViewController = nil;
    dispatch_once(&pred, ^{
        _sharedMenuTableViewController = [[self alloc] init];
    });
    return _sharedMenuTableViewController;
}

- (id)init
{
    return [super init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!self.userInfo || !self.isUserChanged) {
        [self getUserInfo];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:ccr(0, 0, SCREEN_WIDTH, 90)];
    _avator = [[UIImageView alloc] initWithFrame:ccr(20, 20, 50, 50)];
    [_avator setImageWithURL:URL(self.userInfo.avator) placeholderImage:IMG(@"account")];
    _avator.layer.cornerRadius = _avator.width/2;
    _avator.layer.masksToBounds = YES;
    
    [headerView addSubview:_avator];
    
    _nameLabel = [UILabel labelWithFrame:ccr(CGRectGetMaxX(_avator.frame)+10,
                                             20,
                                             SCREEN_WIDTH-CGRectGetMaxX(_avator.frame)-20-20,
                                             _avator.height/2)
                                   color:COLORRGB(0x000000)
                                    font:HSFONT(15)
                                    text:self.userInfo.mobile?@"已绑定手机":@"未绑定手机"];
    [headerView addSubview:_nameLabel];
    
    _phoneLabel = [UILabel labelWithFrame:ccr(_nameLabel.x,
                                              CGRectGetMaxY(_nameLabel.frame),
                                              _nameLabel.width,
                                              _avator.height/2)
                                    color:COLORRGB(0x000000)
                                     font:HSFONT(15)
                                     text:self.userInfo.mobile];
    [headerView addSubview:_phoneLabel];
    
//    UIImageView *arrow = [[UIImageView alloc] initWithFrame:ccr(SCREEN_WIDTH-20-20, (headerView.height - 30)/2, 30, 30)];
//    arrow.image = IMG(@"arrow_right");
//    [headerView addSubview:arrow];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:ccr(15, CGRectGetMaxY(headerView.frame)-0.7, SCREEN_WIDTH-15, 0.7)];
    line.backgroundColor = COLORRGB(0xd7d7d7);
    [headerView addSubview:line];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)getUserInfo
{
    if (![UICKeyChainStore stringForKey:KEY_STORE_ACCESS_TOKEN service:KEY_STORE_SERVICE]) {
        [ZBCToast showMessage:@"请先登录"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [[DuDuAPIClient sharedClient] GET:TOKEN_LOGIN parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [DuDuAPIClient parseJSONFrom:responseObject];
        self.userInfo = [MTLJSONAdapter modelOfClass:[UserModel class]
                              fromJSONDictionary:dic[@"user"]
                                           error:nil];
        [_avator setImageWithURL:URL(self.userInfo.avator) placeholderImage:IMG(@"account")];
        _nameLabel.text = self.userInfo.mobile?@"已绑定手机":@"未绑定手机";
        _phoneLabel.text = self.userInfo.mobile;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.iconImage.image = IMG(@"tiny_history");
        cell.title = @"我的行程";
    } else if (indexPath.row == 1) {
        cell.iconImage.image = IMG(@"tiny_coupon");
        cell.title = @"我的钱包";
        [cell addSubview:[self walletLabel]];
    } else if (indexPath.row == 2) {
        cell.iconImage.image = IMG(@"tiny_shared");
        cell.title = @"推荐有奖";
    }
//    else if (indexPath.row == 3) {
//        cell.iconImage.image = IMG(@"tiny_unbind");
//        cell.title = @"解除手机绑定";
//    }
    else {
        cell.iconImage.image = IMG(@"tiny_bill");
        cell.title = @"设置";
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyRouteVC *myRouteVC = [[MyRouteVC alloc] init];
        myRouteVC.title = @"我的行程";
        [self.navigationController pushViewController:myRouteVC animated:YES];
    } else if (indexPath.row == 1) {
        MyWalletVC *myWalletVC = [[MyWalletVC alloc] init];
        myWalletVC.title = @"优惠券";
        [self.navigationController pushViewController:myWalletVC animated:YES];
    } else if (indexPath.row == 2) {
        RecommendVC *recommendVC = [[RecommendVC alloc] init];
        recommendVC.title = @"推荐有奖";
        [self.navigationController pushViewController:recommendVC animated:YES];
    }
//    else if (indexPath.row == 3) {
//        
//    }
    else {
        SettingsVC *settingsVC = [[SettingsVC alloc] init];
        settingsVC.title = @"设置";
        [self.navigationController pushViewController:settingsVC animated:YES];
    }
}

- (UILabel *)walletLabel
{
    UILabel *walletLabel = [UILabel labelWithFrame:CGRectZero
                                             color:COLORRGB(0xd7d7d7)
                                              font:HSFONT(12)
                                              text:@"券、发票"
                                         alignment:NSTextAlignmentRight
                                     numberOfLines:1];
    CGSize walletSize = [walletLabel.text sizeWithAttributes:@{NSFontAttributeName:walletLabel.font}];
    [walletLabel sizeToFit];
    walletLabel.frame = ccr(SCREEN_WIDTH-30-walletSize.width,
                            (60-walletSize.height)/2,
                            walletSize.width,
                            walletSize.height);
    return walletLabel;
}

@end
