//
//  SJAddViewController.h
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJExcelModel.h"

typedef void (^AddDataBlock)(SJExcelModel * _Nonnull model);
NS_ASSUME_NONNULL_BEGIN

@interface SJAddViewController : UIViewController
@property (nonatomic,strong) AddDataBlock addDataBlock;
@property (nonatomic,strong) NSMutableArray *muDataArray;
@end

NS_ASSUME_NONNULL_END
