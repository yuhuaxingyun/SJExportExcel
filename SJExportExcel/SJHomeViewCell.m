//
//  SJHomeViewCell.m
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "SJHomeViewCell.h"
#import <objc/runtime.h>
#import <Masonry.h>

@interface SJHomeViewCell()
@property (nonatomic,strong) NSArray *keyArray;
@end

@implementation SJHomeViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setExcelModel:(SJExcelModel *)excelModel{
    self.keyArray = [excelModel getAllProperties];
    for (int i=0; i<self.keyArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10+i*20);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *infoLabel = [[UILabel alloc]init];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10+i*20);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(20);
        }];
        
        NSString *key = [self.keyArray objectAtIndex:i];
        titleLabel.text = [NSString stringWithFormat:@"%@",key];
        NSString *infoStr = [SJExcelModel getPropertWithPropertyName:key model:excelModel];
        infoLabel.text = infoStr;
    }
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
