//
//  EZLLauncher.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 09.07.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

#import "EZLLauncher.h"
#import "Einkaufszettl-Swift.h"

@implementation EZLLauncher

- (id) init {
    self = [super init];
    
    if (self != nil) {
        self.language = [[[NSLocale preferredLanguages] objectAtIndex:0] substringWithRange:NSMakeRange(0, 2)];
    }
    
    return self;
}

- (void)readInitialData {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHasLaunchedOnceKey] != YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasLaunchedOnceKey];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMigrationDoneKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMaxDisplayOrderValueBugFixedKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMaxDisplayOrderValueBugFixedAlertShownKey];

        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *units_de_path = [[NSBundle mainBundle] pathForResource:@"units-de" ofType:@"json"];
        NSString *things_de_path = [[NSBundle mainBundle] pathForResource:@"things-de" ofType:@"json"];
        
        NSString *units_en_path = [[NSBundle mainBundle] pathForResource:@"units-en" ofType:@"json"];
        NSString *things_en_path = [[NSBundle mainBundle] pathForResource:@"things-en" ofType:@"json"];
        NSString *categories_de_path = [[NSBundle mainBundle] pathForResource:@"categories-de" ofType:@"json"];
        NSString *categories_en_path = [[NSBundle mainBundle] pathForResource:@"categories-en" ofType:@"json"];
        
        if ([self.language isEqualToString:@"de"]) {
            [self getDefaultCategoriesFromPath:categories_de_path];
            [self getDefaultUnitsFromPath:units_de_path];
            [self getDefaultThingsFromPath:things_de_path];
        } else {
            [self getDefaultCategoriesFromPath:categories_en_path];
            [self getDefaultUnitsFromPath:units_en_path];
            [self getDefaultThingsFromPath:things_en_path];
        }
    }
}

- (void)migrateCategories {
    // new Migration
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kMigrationDoneKey] != YES) {
        // fetch all saved
        NSFetchRequest *fetchAllCategories = [NSFetchRequest fetchRequestWithEntityName:@"ProductCategory"];
        NSError *fetchError;
        NSError *error;
        NSArray *allCategories = [self.managedObjectContext executeFetchRequest:fetchAllCategories error:&fetchError];
        NSString *categoriesPath = [[NSBundle mainBundle] pathForResource:@"categories-de" ofType:@"json"];
        NSMutableArray *defaultCategories;
        NSInteger currentOrderValue = 0;
       
        if([self.language isEqualToString:@"de"] == NO) {
            categoriesPath = [[NSBundle mainBundle] pathForResource:@"categories-en" ofType:@"json"];
        }
        
        if (allCategories == nil) {
            return;
        }
        
        // read default-categories into dicts
        NSData *file = [NSData dataWithContentsOfFile:categoriesPath];
        if (file == nil) {
            return;
        }
        
        defaultCategories = [NSJSONSerialization JSONObjectWithData:file
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        if(error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        // Plan: Add DisplayOrderValues to defaultCategories first
        // Then: Add displayOrderValues to custom categories afterwards.
        for (ProductCategory *category in allCategories) {
            // for (NSDictionary categoryDict in allCategoriesFromDisk)
            // check for Names: category.name isEqualToString:[categoryDict valueForKey:name]
            // category.displayOrderValue = [categoryDict valueForKey:displayOrderValue]
            for (NSDictionary *catDict in defaultCategories) {
                NSString *defaultCatName = [catDict valueForKey:@"name"];
                NSInteger displayOrderValue = [[catDict valueForKey:@"displayOrderValue"] integerValue];
                //TODO: Probably not very robust, needs some refactoring?
                
                if ([category.name isEqualToString:defaultCatName] == YES) {
                    category.displayOrderValue = [NSNumber numberWithInteger:displayOrderValue];
                    currentOrderValue++;
                }
            }
            
        }
        
        // iterate over all things and check, if there's a number.
        // if no: set defaultNumber and increase by one.
        for (ProductCategory *category in allCategories) {
            
            category.hidden = [NSNumber numberWithBool:NO];
            
            if(category.displayOrderValue == nil) {
                category.displayOrderValue = [NSNumber numberWithInteger:currentOrderValue];
                currentOrderValue++;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:currentOrderValue forKey:kMaxOrderValueKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMigrationDoneKey];
    }
    
    // kMaxDisplayOrderValueBugFixedKey
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kMaxDisplayOrderValueBugFixedKey] != YES) {
        NSFetchRequest *fetchAllCategories = [NSFetchRequest fetchRequestWithEntityName:@"ProductCategory"];
        NSError *fetchError;
        NSError *error;
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrderValue" ascending:YES];
        fetchAllCategories.sortDescriptors = @[sortDescriptor];
        NSArray *allCategories = [self.managedObjectContext executeFetchRequest:fetchAllCategories error:&fetchError];
        
        if (fetchError == nil) {
            int displayOrderValue = 0;
            for (ProductCategory *category in allCategories) {
                category.displayOrderValue = [NSNumber numberWithInt:displayOrderValue];
                displayOrderValue++;
            }
        }
        
        
        if([[self managedObjectContext] save:&error] == YES) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMaxDisplayOrderValueBugFixedKey];
        } else {
            NSLog(@"Couldn't fix displayOrderValue-bug");
        }
    }
}

//TODO: Needs Refactoring
- (BOOL)getDefaultCategoriesFromPath:(NSString *)path
{
    NSError *error;
    NSMutableArray *categories;
    
    NSData *file = [NSData dataWithContentsOfFile:path];
    
    if(!file) {
        NSLog(@"Check File Path for Categories!");
        return NO;
    }
    else {
        categories = [NSJSONSerialization JSONObjectWithData:file
                                                     options:NSJSONReadingMutableContainers
                                                       error:&error];
        if(error) {
            NSLog(@"%@", error.localizedDescription);
            return NO;
        } else {
            
            NSNumber *maxOrderValue = [NSNumber numberWithInt:0];
            for (NSDictionary *currCategory in categories) {
                
                if ([[currCategory valueForKey:@"name"] isEqualToString:@"Diary Case"] == YES) {
                    continue;
                }
                
                ProductCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCategory" inManagedObjectContext:self.managedObjectContext];
                category.name = [currCategory valueForKey:@"name"];
                
                NSNumber *displayOrderValue = [currCategory valueForKey:@"displayOrderValue"];
                category.displayOrderValue = displayOrderValue;
                if (displayOrderValue >= maxOrderValue) {
                    maxOrderValue = displayOrderValue;
                }
                
                category.hidden = [NSNumber numberWithBool:NO];
                
            }
            [[NSUserDefaults standardUserDefaults] setInteger:maxOrderValue.integerValue forKey:kMaxOrderValueKey];
            
            if(![[self managedObjectContext] save:&error]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)getDefaultUnitsFromPath:(NSString *)path
{
    // TODO Refactor. Asynchronous fetching and stuff like that.
    // TODO testing This two functions suck!
    NSError *error;
    NSMutableArray *units;
    
    NSData *file = [NSData dataWithContentsOfFile:path];
    
    if(!file) {
        NSLog(@"Check File Path for Units!");
        return NO;
    }
    else {
        units = [NSJSONSerialization JSONObjectWithData:file
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
        if(error) {
            NSLog(@"%@", error.localizedDescription);
            return NO;
        } else {
            
            for (NSDictionary *currUnit in units) {
                ProductUnit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"ProductUnit"
                                                           inManagedObjectContext:self.managedObjectContext];
                [unit setName:[currUnit valueForKey:@"name"]];
            }
            
            if(![[self managedObjectContext] save:&error]) {
                NSLog(@"Saving failed for the following reason: %@", error.localizedDescription);
            
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)getDefaultThingsFromPath:(NSString *)path {
    NSError *error;
    NSMutableArray *things;
    
    NSData *file = [NSData dataWithContentsOfFile:path];
    
    ProductUnit *unit;
    ProductCategory *category;
    if(!file) {
        NSLog(@"Check File Path for Things!");
        return NO;
    }
    else {
        things = [NSJSONSerialization JSONObjectWithData:file
                                                 options:NSJSONReadingMutableContainers
                                                   error:&error];
        if(error) {
            NSLog(@"%@", error.localizedDescription);
            return NO;
        } else {
            
            for (NSDictionary *currThing in things) {
                Product *thing = [NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                                             inManagedObjectContext:self.managedObjectContext];
                
                NSFetchRequest *unitFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductUnit"];
                NSFetchRequest *categoryFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductCategory"];
                [unitFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@", [currThing valueForKey:@"unit"]]];
                [categoryFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@", [currThing valueForKey:@"category"]]];
                // TODO Is this a clean way?
                unit = [[[self managedObjectContext] executeFetchRequest:unitFetchRequest
                                                                   error:&error] objectAtIndex:0];
                category = [[[self managedObjectContext] executeFetchRequest:categoryFetchRequest
                                                                       error:&error] objectAtIndex:0];
                
                if(error) {
                    return NO;
                }
                
                [thing setName:[currThing valueForKey:@"name"]];
                thing.unit = unit;
                thing.category = category;
                [thing setAmount:[currThing valueForKey:@"amount"]];
                [thing setBought:[currThing valueForKey:@"bought"]];
                [thing setOnList:[currThing valueForKey:@"onList"]];
            }
            
            [[self managedObjectContext] save:&error];
            if(error) {
                return NO;
            }
        }
    }
    
    return YES;
}

//TODO: Method, that prepares data for snapshot:
/*
 if NSUserDefaults.standardUserDefaults().boolForKey("FASTLANE_SNAPSHOT") {
 // runtime check that we are in snapshot mode
 }
 */
@end
