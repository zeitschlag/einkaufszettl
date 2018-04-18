//
//  EZLCategoryDetailTableViewController.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 10.12.15.
//  Copyright © 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZLCategoryDetailDataSource;
@class ProductCategory;

@interface EZLCategoryDetailTableViewController : UITableViewController

@property ProductCategory *category;
@property EZLCategoryDetailDataSource *dataSource;
@property NSManagedObjectContext *managedObjectContext;

- (IBAction)saveThingCategory:(id)sender;
@end
