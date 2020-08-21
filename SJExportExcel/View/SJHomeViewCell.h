//
//  SJHomeViewCell.h
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJExcelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJHomeViewCell : UITableViewCell
@property (nonatomic,strong) SJExcelModel *excelModel;

@end

NS_ASSUME_NONNULL_END
