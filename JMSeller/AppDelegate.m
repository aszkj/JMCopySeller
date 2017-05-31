//
//  AppDelegate.m
//  JMSeller
//
//  Created by JM on 2017/5/16.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JMLoginController.h"
#import "JMSellerBaseNavController.h"
#import "JMHomeController.h"
#import "ProjectNormalConst.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self _configureKeyBoard];
    
    [self _configureLog];

    [self _entrance];
    
    return YES;
}

- (void)_entrance {
    if (SESSIONID) {
        [self _enterMain];
    }else{
        [self _enterLogin];
    }
}

- (void)_configureKeyBoard {
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)_enterMain {
    
    JMHomeController *homeVC = [[JMHomeController alloc] init];
    JMSellerBaseNavController *baseNav = [[JMSellerBaseNavController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = baseNav;
}

- (void)_configureLog {
    // 实例化 lumberjack
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // 允许颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

- (void)_enterLogin {
    JMLoginController *loginVc = [[JMLoginController alloc] init];
    JMSellerBaseNavController *loginNav = [[JMSellerBaseNavController alloc] initWithRootViewController:loginVc];
    self.window.rootViewController = loginNav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
