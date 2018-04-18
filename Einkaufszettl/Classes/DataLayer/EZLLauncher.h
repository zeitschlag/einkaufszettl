//
//  EZLLauncher.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 09.07.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "EinkaufszettlConstants.h"

@interface EZLLauncher : NSObject

@property NSManagedObjectContext *managedObjectContext;
@property NSString *language;

- (void)readInitialData;
- (void)migrateCategories;

@end
