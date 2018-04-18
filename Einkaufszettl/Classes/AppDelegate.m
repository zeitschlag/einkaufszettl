//
//  AppDelegate.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.03.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import "AppDelegate.h"
#import "EZLLauncher.h"
#import "EinkaufszettlConstants.h"
#import "Einkaufszettl-Swift.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate

@synthesize mainTableViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    
    EZLLauncher *launcher = [[EZLLauncher alloc] init];
    launcher.managedObjectContext = [CoreDataStack shared].persistentContainer.viewContext;
    [launcher readInitialData];
    [launcher migrateCategories];
    
    NSString *kAskedUserForNotification = @"kAskedUserForNotification";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kAskedUserForNotification] == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAskedUserForNotification];
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == YES) {
                NSLog(@"User allowed notification");
            }
        }];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NumberOfBoughtThingsChanged:) name:kNumberOfBoughtThingsChangedNotificationName object:nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:kNumberOfBoughtThingsChangedNotificationName object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:kNumberOfBoughtThingsChangedNotificationName object:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNumberOfBoughtThingsChangedNotificationName object:nil];
    [CoreDataStack.shared saveContext];
}

#pragma mark - Notifications

- (void)NumberOfBoughtThingsChanged:(NSNotification *)notification {
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.badgeSetting == UNNotificationSettingEnabled) {
            NSFetchRequest *unboughtThingsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"onList == 1 && bought == 0"];
            unboughtThingsRequest.predicate = predicate;
            
            NSError *error;
            NSUInteger amount = [CoreDataStack.shared.persistentContainer.viewContext countForFetchRequest:unboughtThingsRequest error:&error];
            
            if (error != nil) {
                NSLog(@"Couldn't update badge-number: %@", error.localizedDescription);
                amount = 0;
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIApplication sharedApplication].applicationIconBadgeNumber = amount;
            }];
            
        }
    }];
    
}

@end
