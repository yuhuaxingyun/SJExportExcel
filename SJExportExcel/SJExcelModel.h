//
//  SJExcelModel.h
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJExcelModel : JSONModel
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *money;
/*
 * 获取对象的所有属性
 */
- (NSArray *)getAllProperties;
/*
* 动态添加属性
*/
+ (void)addPropertWithPropertyName:(NSString *)propertyName;
/*
* 动态修改属性或赋值
*/
+ (void)setPropertWithPropertyName:(NSString *)propertyName value:(id)value model:(id)model;
/*
* 获取当前属性的值
*/
+ (NSString *)getPropertWithPropertyName:(NSString *)propertyName model:(SJExcelModel *)model;

@end

NS_ASSUME_NONNULL_END
