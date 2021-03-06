//
//  SettingCell.m
//  DuDu
//
//  Created by 教路浩 on 15/12/2.
//  Copyright © 2015年 i-chou. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
{
    UILabel     *_conditionLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    _conditionLabel = [UILabel labelWithFrame:ccr(0, 0, SCREEN_WIDTH, 60)
                                        color:COLORRGB(0x000000)
                                         font:HSFONT(15)
                                         text:@""
                                    alignment:NSTextAlignmentCenter
                                numberOfLines:1];
    [self.contentView addSubview:_conditionLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _conditionLabel.text = self.condition;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
