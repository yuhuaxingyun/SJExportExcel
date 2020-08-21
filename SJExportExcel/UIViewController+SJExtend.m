//
//  UIViewController+SJExtend.m
//  SJExportExcel
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "UIViewController+SJExtend.h"

@implementation UIViewController (SJExtend)
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                                          
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
