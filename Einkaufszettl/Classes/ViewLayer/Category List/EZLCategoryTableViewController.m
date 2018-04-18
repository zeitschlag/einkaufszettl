//
//  EZLCategoryTableViewController.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 10.12.15.
//  Copyright © 2015 Nathan Mattes. All rights reserved.
//

#import "EZLCategoryTableViewController.h"
#import "EinkaufszettlConstants.h"
#import "Einkaufszettl-Swift.h"

@interface EZLCategoryTableViewController ()

@end

@implementation EZLCategoryTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"CATEGORIES.TITLE", nil);
    
    NSError *error;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductCategory"];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"displayOrderValue"
                                                                                       ascending:YES]]];
    
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:self.managedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    
    [self.resultsController setDelegate:self];
    [self.resultsController performFetch:&error];
    
    // TODO Fetch objects when view appears?
    if(error) {
        NSLog(@"Error while fetching the objects: %@", [error localizedDescription]);
    }
    
    self.searchController = [[EZLSearchController alloc] initWithSearchResultsController:nil]; //self.searchResultsTableController];
    [self.searchController setSearchResultsUpdater:self];
    [self.searchController setDelegate:self];
    [self.searchController setDimsBackgroundDuringPresentation:NO];
    [self.searchController setDefinesPresentationContext:YES];
    [self.searchController setHidesNavigationBarDuringPresentation:NO];
    
    self.searchController.searchBar.delegate = self;
    [[self.searchController searchBar] setTintColor:self.view.tintColor ];
    [[self.searchController searchBar] setSearchBarStyle:UISearchBarStyleMinimal];
    [[self.searchController searchBar] setPlaceholder:NSLocalizedString(@"search category placeholder", nil)];
    
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    [[self.searchController searchBar] sizeToFit];
    
    self.searchController.searchBar.showsCancelButton = NO;
    self.definesPresentationContext = YES;
    
    self.tableView.dataSource = self;
    // self.title = NSLocalizedString(@"units.title", @"Title for list which contains all units");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(self.searchController.active) {
        [[[self searchController] searchBar] resignFirstResponder];
        [[self navigationController] popViewControllerAnimated:YES];
        [[self tableView] becomeFirstResponder];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate-methods
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeInsert:
            
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                    withRowAnimation:UITableViewRowAnimationTop];
            break;
        default:
            break;
    }
}

#pragma mark - UISearchControllerDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSError *error;
    // TODO Refactoring: Put this in its own method
    NSString *searchText = [[[self searchController] searchBar] text];
    if([searchText isEqualToString:@""]) {
        [[self.resultsController fetchRequest] setPredicate:nil];
        self.createNewCategoryButton.enabled = NO;
    } else {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains [c] %@", searchText];
        [[self.resultsController fetchRequest] setPredicate:searchPredicate];
        self.createNewCategoryButton.enabled = YES;
    }
    
    if(![self.resultsController performFetch:&error]) {
        NSLog(@"%@", error.localizedDescription);
    }
    [[self tableView] reloadData];
}

#pragma mark - Actions

- (IBAction)doneClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createNewCategory:(id)sender {
    NSError *error;
    NSString *name = [[[self searchController] searchBar] text];
    NSInteger maxOrderValue = [[NSUserDefaults standardUserDefaults] integerForKey:kMaxOrderValueKey];
    maxOrderValue++;
    
    ProductCategory *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCategory"inManagedObjectContext:self.managedObjectContext];
    newCategory.name = name;
    //[ProductCategory initWithManagedObjectContext:self.managedObjectContext
//                                                                    withName:name];
    newCategory.displayOrderValue = [NSNumber numberWithInteger:maxOrderValue];
    [[NSUserDefaults standardUserDefaults] setInteger:maxOrderValue forKey:kMaxOrderValueKey];
    
    newCategory.hidden = [NSNumber numberWithBool:NO];
    
    self.product.category = newCategory;
    
    if ([self.managedObjectContext save:&error] == NO) {
        NSLog(@"Creating new thing category failed due to this reason: %@", error.localizedDescription);
    }
    [[self tableView] reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([SettingsManager.shared currentSelectionMode] != SelectionModeTap) {
        return;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectProductCategoryAtIndexPath:indexPath];
}

- (void)selectProductCategoryAtIndexPath:(NSIndexPath *)indexPath {
    self.product.category = (ProductCategory *)[self.resultsController objectAtIndexPath:indexPath];
    
    NSError *error;
    
    if([self.managedObjectContext save:&error] == NO) {
        NSLog(@"Error setting Unit of Thing: %@", error.localizedDescription);
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SettingsManager.shared currentSelectionMode] == SelectionModeTap) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SettingsManager.shared currentSelectionMode] == SelectionModeSwipe) {
        return YES;
    } else {
        return NO;
    }

}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([SettingsManager.shared currentSelectionMode] != SelectionModeSwipe) {
        return nil;
    }

    UIContextualAction *selectAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"SELECT.THIS_CATEGORY", nil) handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self selectProductCategoryAtIndexPath:indexPath];
        completionHandler(YES);
    }];
    
    selectAction.backgroundColor = [Branding.shared actionColor];
    
    UISwipeActionsConfiguration *swipeActionConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[selectAction]];
    
    swipeActionConfiguration.performsFirstActionWithFullSwipe = YES;
    
    return swipeActionConfiguration;

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.resultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell"
                                                            forIndexPath:indexPath];
    ProductCategory *category = [[self resultsController] objectAtIndexPath:indexPath];

    if([self.product.category isEqual:category]) {
        cell.textLabel.font = [Branding.shared selectedItemFont];
    } else {
        cell.textLabel.font = [Branding.shared unselectedItemFont];
    }
    if(![[category name] isEqualToString:@""]) {
        [[cell textLabel] setText:category.name];
    } else {
        [[cell textLabel] setText:NSLocalizedString(@"no_name", nil)];
    }
    
    return cell;
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    ProductCategory *selectedCategory = [self.resultsController objectAtIndexPath:indexPath];
    if([segue.identifier isEqualToString:@"showCategoryDetails"]) {
        EZLCategoryDetailTableViewController *vc = (EZLCategoryDetailTableViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.category = selectedCategory;
    }
    
}

@end
