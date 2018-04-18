//
//  AppDelegate.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.03.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class EZLShoppingListTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property EZLShoppingListTableViewController *mainTableViewController;

@end

