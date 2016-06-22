//
//  AppDelegate.m
//  FirebaseDemo
//
//  Created by Miguel Melendez on 6/21/16.
//  Copyright © 2016 Miguel Melendez. All rights reserved.
//

#import "AppDelegate.h"

@import Firebase;
@import FirebaseMessaging;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    
    
    // Add an oberver for handling a token refresh callback
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(tokenRefreshCallback:)
                                          name:kFIRInstanceIDTokenRefreshNotification
                                          object:nil];
    
    // Request permission for notifications from the user
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    
    //Request a device token from Apple Push Notification Services
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCN");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFirebase];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Print Message ID
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    // Print Full Message
    NSLog(@"%@", userInfo);
    
}

#pragma mark -- Custom Ffirebase code

- (void)tokenRefreshCallback: (NSNotification *)notification {
    NSString *refreshToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFirebase];
}

- (void)connectToFirebase {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM");
        }
    }];
}

@end
