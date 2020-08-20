//
//  SJAddViewCell.m
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "SJAddViewCell.h"
#import <Masonry/Masonry.h>

@interface SJAddViewCell()<UITextFieldDelegate>

@end

@implementation SJAddViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.infoField];
    [self.infoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
}

- (void)setKey:(NSString *)key{
    self.titleLabel.text = key;
}

- (void)setValue:(NSString *)value{
    self.infoField.text = value;
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self.delegate inputTextFieldText:textField.text addViewCell:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UITextField *)infoField{
    if (!_infoField) {
        UITextField *infoField = [[UITextField alloc]init];
        infoField.textColor = [UIColor blackColor];
        infoField.delegate = self;
        [infoField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        infoField.placeholder = @"请输入值";
        _infoField = infoField;
    }
    return _infoField;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
