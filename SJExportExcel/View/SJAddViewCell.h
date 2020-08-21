//
//  SJAddViewCell.h
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPropertyModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SJAddViewCell;

@protocol SJAddViewCellDelegate <NSObject>

- (void)inputTextFieldText:(NSString *)text addViewCell:(SJAddViewCell *)addViewCell;

@end
@interface SJAddViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *infoField;
@property (nonatomic,weak) id<SJAddViewCellDelegate> delegate;
@property (nonatomic,strong) SJPropertyModel *propertyModel;
@end

NS_ASSUME_NONNULL_END
