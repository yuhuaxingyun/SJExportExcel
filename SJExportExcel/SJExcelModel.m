//
//  SJExcelModel.m
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "SJExcelModel.h"
#import <objc/runtime.h>

@interface SJExcelModel()

@end
@implementation SJExcelModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
//获取对象的所有属性
- (NSArray *)getAllProperties{
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
/*
 *  获取类中指定名称实例成员变量的信息
 */
+ (void)getPropertWithKey:(const char *)key{
    class_getInstanceVariable([SJExcelModel class], key);
}
/*
* 动态添加属性
*/
+ (void)addPropertWithPropertyName:(NSString *)propertyName{
    // value:属性的赋值，根据属性值，判断属性类型
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership = { "&", "N" };
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    unsigned int attrsCount = 3;
    if (class_addProperty([SJExcelModel class], [propertyName UTF8String], attrs, attrsCount)) {
        [[SJExcelModel class] addPropertWithPropertyName:propertyName];
    }
}

/*
* 动态修改属性或赋值
*/
+ (void)setPropertWithPropertyName:(NSString *)propertyName value:(id)value model:(id)model{
    
    const char * keyChar = [[NSString stringWithFormat:@"_%@",propertyName] UTF8String];
    Ivar m_name = class_getInstanceVariable(self, keyChar);
    object_setIvar(model, m_name, value);
}

/*
* 获取当前属性的值
*/
+ (NSString *)getPropertWithPropertyName:(NSString *)propertyName model:(SJExcelModel *)model{
    const char * keyChar = [[NSString stringWithFormat:@"_%@",propertyName] UTF8String];
    Ivar m_name = class_getInstanceVariable(self, keyChar);
    NSString *str = (NSString *)object_getIvar(model, m_name);
    return str;
}

@end
