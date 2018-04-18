//
//  EZLUnitTableViewController.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 22.04.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import "EZLUnitTableViewController.h"
#import "Einkaufszettl-Swift.h"

@implementation EZLUnitTableViewController

#pragma mark - Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"UNITS.TITLE", nil);
    
    NSError *error;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductUnit"];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                       ascending:YES]]];
    
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:self.managedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    
    [self.resultsController setDelegate:self];
    
    
    // TODO Fetch objects when view appears?
    if([self.resultsController performFetch:&error] == NO) {
        NSLog(@"Error while fetching the objects: %@", error.localizedDescription);
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
    [[self.searchController searchBar] setPlaceholder:NSLocalizedString(@"search unit placeholder", nil)];
    
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    [[self.searchController searchBar] sizeToFit];
    
    self.searchController.searchBar.showsCancelButton = NO;
    self.definesPresentationContext = YES;
        
    self.dataSource = [[EZLUnitDataSource alloc] init];
    self.dataSource.product = self.product;
    self.dataSource.resultsController = self.resultsController;
    self.dataSource.tintColor = self.view.tintColor;
    
    self.tableView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    
    [self selectProductUnitAtIndexPath:indexPath];
}

- (void)selectProductUnitAtIndexPath:(NSIndexPath *)indexPath {

    self.product.unit = [self.resultsController objectAtIndexPath:indexPath];
    
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
    
    UIContextualAction *selectAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"SELECT.THIS_UNIT", nil) handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self selectProductUnitAtIndexPath:indexPath];
        
        completionHandler(YES);
        
//        [NSOperationQueue.mainQueue addOperationWithBlock:^{
//            [tableView setEditing:NO animated:YES];
//        }];
        
    }];
    
    selectAction.backgroundColor = [Branding.shared actionColor];
    
    UISwipeActionsConfiguration *swipeActionConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[selectAction]];
    
    swipeActionConfiguration.performsFirstActionWithFullSwipe = YES;
    
    return swipeActionConfiguration;
    
}


#pragma mark - Scroll view delegate
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [[self tableView] reloadData];
            break;
            
        case NSFetchedResultsChangeInsert:
            
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                    withRowAnimation:UITableViewRowAnimationTop];
            break;
        default:
            break;
    }
}

#pragma mark - UISearchControllerDelegate-methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSError *error;
    // TODO Refactoring: Put this in its own method
    NSString *searchText = self.searchController.searchBar.text;
    if([searchText isEqualToString:@""]) {
        [[self.resultsController fetchRequest] setPredicate:nil];
        self.createNewUnitButton.enabled = NO;
    } else {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains [c] %@", searchText];
        [[self.resultsController fetchRequest] setPredicate:searchPredicate];
        self.createNewUnitButton.enabled = YES;
    }
    
    if([self.resultsController performFetch:&error] == NO) {
        NSLog(@"%@", error.localizedDescription);
    }
    [[self tableView] reloadData];
}

#pragma mark - own methods

- (IBAction)doneClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createNewUnit:(id)sender {
    NSError *error;
    NSString *name = self.searchController.searchBar.text;
    ProductUnit *newUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ProductUnit"
                                                         inManagedObjectContext:self.managedObjectContext];
    newUnit.name = name;
    self.product.unit = newUnit;
    
    if ([self.managedObjectContext save:&error] == NO) {
        NSLog(@"Creating new thing failed due to this reason: %@", error.localizedDescription);
    }
    [[self tableView] reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    ProductUnit *selectedUnit = [self.resultsController objectAtIndexPath:indexPath];
    if([segue.identifier isEqualToString:@"showUnitDetails"]) {
        EZLUnitDetailTableViewController *vc = (EZLUnitDetailTableViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.unit = selectedUnit;
    }
}

@end
