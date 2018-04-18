//
//  EZLUnitTableViewController.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 22.04.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "EZLUnitDataSource.h"
#import "EZLSearchController.h"

@class EZLUnitSwipeTableCellDelegate;
@class Product;
@class ProductUnit;

@interface EZLUnitTableViewController: UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *resultsController;
@property EZLSearchController *searchController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createNewUnitButton;
@property Product *product;
@property EZLUnitDataSource *dataSource;


- (IBAction)doneClick:(id)sender;
- (IBAction)createNewUnit:(id)sender;

@end
