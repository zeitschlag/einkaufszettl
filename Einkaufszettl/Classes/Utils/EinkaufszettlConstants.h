//
//  EinkaufszettlConstants.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 19.04.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

#ifndef EinkaufszettlConstants_h
#define EinkaufszettlConstants_h

#pragma mark - UserDefault-keys

static NSString * const kAskedUserForNotification = @"kAskedUserForNotification";

static NSString * const kMaxOrderValueKey = @"MaxOrderValue";
static NSString * const kMigrationDoneKey = @"MigrationDone";
static NSString * const kHasLaunchedOnceKey = @"HasLaunchedOnce";

static NSString * const kMaxDisplayOrderValueBugFixedKey = @"de.bullenscheisse.maxDisplayOrderValueBugFixed";
static NSString * const kMaxDisplayOrderValueBugFixedAlertShownKey = @"de.bullenscheisse.maxDisplayOrderValueBugAlertShown";

#pragma mark - Notifications
//TODO: Replace those with Swift-Constants.
static NSString * const kShoppingFinishedNotificationName = @"ShoppingFinished";
static NSString * const kNumberOfBoughtThingsChangedNotificationName = @"NumberOfBoughtThingsChanged";
static NSString * const kOrderOfCategoriesChangedNotificationName = @"OrderOfCategoriesChanged";
#endif /* EinkaufszettlConstants_h */
