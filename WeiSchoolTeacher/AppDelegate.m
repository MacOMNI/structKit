//
//  AppDelegate.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/10.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "AppDelegate.h"
#import "UIViewController+MLTransition.h"
#import "RCStatusManager.h"
#import <KSCrash/KSCrashInstallationEmail.h>


//#define RONGCLOUD_IM_APPKEY @"8luwapkvufwvl" //测试环境
#define RONGCLOUD_IM_APPKEY @"8brlm7ufr4lf3" //线上环境

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //配置主控制器
    [self configureRootViewController];
    //注册通知
    [[UIApplication sharedApplication]registerNotifications];
    //Crash report
    [self installCrashHandler];
    //配置荣云
    //[self configureRCIM];
    //配置常用控件
    [self configureUI];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark privite methods
/**
 *  配置主控制器
 */
- (void)configureRootViewController{
    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    MainTabBarController *tarBarController=[[MainTabBarController alloc]init];
    self.mainViewController = [[MainViewController alloc] initWithRootViewController:tarBarController];
    self.window.rootViewController = self.mainViewController;
}
/**
 *  配置常用控件
 */
-(void)configureUI
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
    
    alertConfig.defaultTextOK = @"确定";
    alertConfig.defaultTextCancel = @"取消";
    alertConfig.defaultTextConfirm = @"确认";
    
    sheetConfig.defaultTextCancel = @"取消";

}
/**
 *  配置荣云通信参数
 */
- (void)configureRCIM{
    //*********融云**********
    [[RCIM sharedRCIM]initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    
    //状态监听
    [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    //接收消息的监听器
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    //设置会话列表头像和会话界面头像
    if (iphone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    }else{
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    //注册自定义消息
//    [[RCIMClient sharedRCIMClient]registerMessageType:[daoxueMessage class]];
//    [[RCIMClient sharedRCIMClient]registerMessageType:[LittleNewsMessage class]];
    
    // 快速集成第二步，连接融云服务器
    // 登录
   // User *nowUser = [User nowUser];
    NSString *token = @"utoken";
    NSString *userID = @"";
    NSString *userName = @"";
    NSString *userPortrait = @"uZP";
    if (token.length && userID.length) {
        
        RCUserInfo *currentUserInfo = [[RCUserInfo alloc]initWithUserId:[userID stringByReplacingOccurrencesOfString:@"-" withString:@""] name:userName portrait:userPortrait];
        [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
            // Connect 成功
            //NSLog(@"成功");
            //注意这里的 userId != userID 这个项目中uYHBH去掉“-”就是userId了
            DLog(@"userId = %@",userId);
            
            [RCIMClient sharedRCIMClient].currentUserInfo = currentUserInfo;
            RCStatus.status = ConnectionStatus_Connected;
            [[RCIM sharedRCIM]refreshUserInfoCache:currentUserInfo withUserId:userID];
            //为了确保群组关系的正确同步，最好在每次完成初始化并成功连接融云服务后调用此方法。
            [RCDDataSource syncGroups];
            
            //[[RCIM sharedRCIM]clearUserInfoCache];
            //[[RCIM sharedRCIM]clearGroupInfoCache];
            
        } error:^(RCConnectErrorCode status) {
            //Connect 失败
            //NSLog(@"connect error %ld", (long)status);
            RCStatus.status = ConnectionStatus_Unconnected;
            
        } tokenIncorrect:^{
            // Token 失效的状态处理 重新登录获取token
            
            //NSLog(@"token失效");
            RCStatus.status = ConnectionStatus_TOKEN_INCORRECT;
            
            
        }];
    }else{
        
    }
    
    
    /**
     * 统计Push打开率1
     */
    //[[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    
    //派遣消息的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];

}

// ======================================================================
#pragma mark - Basic Crash Handling 
// ======================================================================

- (void) installCrashHandler
{
    KSCrashInstallation* installation = [self makeEmailInstallation];
    [installation install];
    [installation sendAllReportsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error)
     {
         if(completed)
         {
             DLog(@"Sent %d reports", (int)[reports count]);
         }
         else
         {
             DLog(@"Failed to send reports: %@", error);
         }
     
     }];
}

- (KSCrashInstallation*) makeEmailInstallation
{
    
    KSCrashInstallationEmail* email = [KSCrashInstallationEmail sharedInstance];
    email.recipients = @[@"azhengkun@126.com"];
    email.subject = @"Crash Report";
    email.message = @"This is a crash report";
    email.filenameFmt = @"crash-report-%d.txt.gz";
    
    [email addConditionalAlertWithTitle:@"发现漏洞"
                                message:@"app上次加载发现漏洞，是否发送报告到邮箱?"
                              yesAnswer:@"是的"
                               noAnswer:@"不用了，谢谢"];
    
    // Uncomment to send Apple style reports instead of JSON.
    [email setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    
    return email;
}
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    RCStatus.status = status;
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    //demo怎么用的？
    DLog(@"%@ ,%zd",message,left);
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}


#pragma mark - 系统通知

//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    /**
     * 统计Push打开率2
     */
    //[[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    
}
/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计Push打开率3
     */
    //[[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
}

#pragma mark applicaton methods

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //进入后台 显示消息未读数目
    int unreadMsgCount = [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Mac.com.cn.WeiSchoolTeacher" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeiSchoolTeacher" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeiSchoolTeacher.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
