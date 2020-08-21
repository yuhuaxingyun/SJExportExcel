//
//  NSString+SJExtend.m
//  SJExportExcel
//
//  Created by mac on 2020/8/20.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "NSString+SJExtend.h"

@implementation NSString (SJExtend)
- (NSString *)transFormChinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [self mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    
    NSString *returnStr = [pinyin copy];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //返回最近结果
    return returnStr;
}

@end
