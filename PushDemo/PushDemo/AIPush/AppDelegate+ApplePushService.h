//
//  AppDelegate+ApplePushService.h
//  AiPark
//
//  Created by liqi on 2018/10/10.
//  Copyright © 2018年 智慧停车. All rights reserved.
//

#import "AppDelegate.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate (ApplePushService)<UNUserNotificationCenterDelegate>
- (void)pushServiceRegisterNotificationSetting;
@end
