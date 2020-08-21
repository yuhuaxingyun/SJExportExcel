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
#import "SJPropertyModel.h"

@interface SJHomeViewCell()
@property (nonatomic,strong) NSArray *keyArray;
@property (nonatomic,strong) NSMutableArray *allViewsArray;
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
    _excelModel = excelModel;
    //创建之前先清空数据
    for (int i=0; i<self.allViewsArray.count;i++) {
        UIView *view = [self.allViewsArray objectAtIndex:i];
        [view removeFromSuperview];
    }
    [self.allViewsArray removeAllObjects];
    
    //创建
    for (int i=0; i<excelModel.propertyName.count; i++) {
        
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
        
        SJPropertyModel *propertyModel = [excelModel.propertyName objectAtIndex:i];
        titleLabel.text = [NSString stringWithFormat:@"%@",propertyModel.header];
        infoLabel.text = propertyModel.connect;
        
        [self.allViewsArray addObject:titleLabel];
        [self.allViewsArray addObject:infoLabel];
    }
}

- (NSMutableArray *)allViewsArray{
    if (!_allViewsArray) {
        _allViewsArray = [NSMutableArray array];
    }
    return _allViewsArray;
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
