//
//  AppDelegate.m
//  SJExportExcel
//
//  Created by mac on 2020/8/18.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *rootVC = [ViewController new];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:rootVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
