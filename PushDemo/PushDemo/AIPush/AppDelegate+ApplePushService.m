//
//  AppDelegate+ApplePushService.m
//  AiPark
//
//  Created by liqi on 2018/10/10.
//  Copyright © 2018年 智慧停车. All rights reserved.
//

#import "AppDelegate+ApplePushService.h"

@implementation AppDelegate (ApplePushService)

// 注册别名
- (void)pushServiceRegisterNotificationSetting {
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        //获取通知权限(角标,声音,弹框)
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
            }else{
                //用户点击不允许
            }
        }];
    }
#else
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
#endif
        [application registerForRemoteNotifications];
    
}

//iOS8-9系统调用推送方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS8,iOS9系统，收到通知:%@", userInfo);
    [self pushProcess:application pushInfo:userInfo];
}

// 远程通知注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    //解析deviceToken
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSLog(@"deviceToken --- %@",deviceTokenString);
}
//iOS10系统调用推送方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)) {
    UNNotificationRequest *request = notification.request;//收到推送的请求
    UNNotificationContent *content = request.content;//收到推送的内容
    NSDictionary *userInfo = content.userInfo;//收到用户的基本信息
    //    NSNumber *badge = content.badge;//收到推送消息的角标
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//（远程通知） 远程推送的通知类型
        UIApplication *application = [UIApplication sharedApplication];
        [self pushProcess:application pushInfo:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置 UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    NSString* actionIdentifierStr = response.actionIdentifier;
    
    if (@available(iOS 10.0, *)) {
        if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
            NSString* userSayStr = [(UNTextInputNotificationResponse *)response userText];
            
            NSLog(@"actionid = %@\n  userSayStr = %@",actionIdentifierStr, userSayStr);
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            
        }else {
            // 判断为本地通知
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler(); // 系统要求执行这个方法
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification
API_AVAILABLE(ios(10.0)){
    
}
#endif
#pragma mark 处理获取的推送消息内容
- (void)pushProcess:(UIApplication *)application pushInfo:(NSDictionary *)userInfo {
    if(!application || !userInfo){
        return;
    }
    //具体实现  跳转
}



@end
