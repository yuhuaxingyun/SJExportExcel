//
//  SJPropertyModel.h
//  SJExportExcel
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJPropertyModel : JSONModel

@property (nonatomic,copy) NSString *propertyName;
@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *connect;
@property (nonatomic,assign) NSInteger boardType;

@end

NS_ASSUME_NONNULL_END
