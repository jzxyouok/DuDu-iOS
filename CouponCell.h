//
//  CouponCell.h
//  DuDu
//
//  Created by 教路浩 on 15/12/3.
//  Copyright © 2015年 i-chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell

@property (nonatomic, copy)NSString *coupon_title;
@property (nonatomic, copy)NSString *coupon_type;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *condition;

@property (nonatomic, strong)UIImageView *bgImage;

@end
