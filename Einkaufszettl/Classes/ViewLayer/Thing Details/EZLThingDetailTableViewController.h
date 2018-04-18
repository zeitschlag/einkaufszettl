//
//  EZLThingDetailTableViewController.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 09.04.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EZLUnitTableViewController.h"
#import "EZLCategoryTableViewController.h"

@class Product;

@interface EZLThingDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property Product *product;
@property NSManagedObjectContext *managedObjectContext;

- (IBAction)saveThingAction:(id)sender;


@end
