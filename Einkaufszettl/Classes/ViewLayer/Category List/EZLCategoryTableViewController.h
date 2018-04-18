//
//  EZLCategoryTableViewController.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 10.12.15.
//  Copyright © 2015 Nathan Mattes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "EZLCategoryDetailTableViewController.h"
#import "EZLSearchController.h"

@class EZLCategorySwipeTableCellDelegate;
@class Product;

@interface EZLCategoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *resultsController;
@property EZLSearchController *searchController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createNewCategoryButton;
@property Product *product;


- (IBAction)doneClick:(id)sender;
- (IBAction)createNewCategory:(id)sender;

@end
