//
//  NMShoppingThingDetailTVController.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 09.04.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import "EZLThingDetailTableViewController.h"
#import "Einkaufszettl-Swift.h"

@implementation EZLThingDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.product.name;
    if (@available(iOS 13.0, *)) {
        self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //FIXME: Why isn't this method invoked, when accesses trough addNewThingsList?
    [[self tableView] reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([[segue identifier] isEqualToString:@"showUnitTableView"]) {
        [self saveProduct];
        EZLUnitTableViewController *destinationViewController = (EZLUnitTableViewController *)[[segue destinationViewController] topViewController];
        [destinationViewController setManagedObjectContext:self.managedObjectContext];
        destinationViewController.product = self.product;
    } else if ([segue.identifier isEqualToString:@"showCategoryTableView"]) {
        [self saveProduct];
        EZLCategoryTableViewController *destinationViewController = (EZLCategoryTableViewController *)[[segue destinationViewController] topViewController];
        [destinationViewController setManagedObjectContext:self.managedObjectContext];
        destinationViewController.product = self.product;
    }
}

#pragma mark -
    
- (void) saveProduct {
    //TODO: Use a View Model or something to store the temporary data before saving it. Don't use the cells to do so.
    DetailCellWithTextField *nameCell = (DetailCellWithTextField *)[[self tableView] cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0
                                                                                       inSection:0]];
    DetailCellWithTextField *amountCell = (DetailCellWithTextField *)[[self tableView] cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0
                                                                                                       inSection:1]];
    NSString *productName = nameCell.detailTextField.text;

    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormat.groupingSeparator = @"";
    NSNumber *amount = [numberFormat numberFromString:amountCell.detailTextField.text];
    
    NSError *error;
    
    self.product.name = productName;
    if(amount) {
        self.product.amount = amount;
    } else {
        self.product.amount = [NSNumber numberWithInt:0];
    }
    
    if([self.managedObjectContext save:&error] == NO) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *thingDetailCellIdentifier = @"thingDetailCell";
    NSString *unitCellIdentifier = @"unitCell";
    NSString *deleteCellIdentifier = @"deleteButtonCell";
    NSString *selectUnitCellIdentifier = @"selectUnitCell";
    NSString *selectCategoryCellIdentifier = @"selectCategoryCell";
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            DetailCellWithTextField *cell = (DetailCellWithTextField *)[tableView dequeueReusableCellWithIdentifier:thingDetailCellIdentifier forIndexPath:indexPath];
            cell.detailTextField.delegate = cell;
            cell.detailTitleLabel.text = NSLocalizedString(@"name", @"Title Label for Thing's name. This is 'name' in english.");
            cell.detailTextField.text = self.product.name;
                        
            return cell;
            
        } else if(indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCategoryCellIdentifier forIndexPath:indexPath];

            cell.textLabel.text = NSLocalizedString(@"category", @"Description of the Category-TableViewCell");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.product.categoryName];
            
            return cell;
        }
        
    } else if(indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            DetailCellWithTextField *cell = (DetailCellWithTextField *)[tableView dequeueReusableCellWithIdentifier:unitCellIdentifier forIndexPath:indexPath];
            cell.isDecimalNumeric = YES;
            cell.detailTextField.delegate = cell;
            cell.detailTitleLabel.text = NSLocalizedString(@"amount", nil);
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            numberFormatter.groupingSeparator = @"";
            
            NSString *amountString = [numberFormatter stringFromNumber:self.product.amount];
            cell.detailTextField.text = [NSString stringWithFormat:@"%@", amountString];
            cell.detailTextField.keyboardType = UIKeyboardTypeDecimalPad;
            
            return cell;

        } else if(indexPath.row == 1) {

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectUnitCellIdentifier forIndexPath:indexPath];

            cell.textLabel.text = NSLocalizedString(@"unit", @"Title for Cell with Unit's name. In English, this is 'unit'");
            if(self.product.unit != nil && [self.product.unit.name isEqualToString:@""] == NO) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.product.unit.name];
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"no_unit", @"This text appears instead of the unit's name, if there's no unit. In English, this will be 'no unit' or something similar.")];
            }
            
            return cell;
        }
    } // else if (indexPath.section == 2) {
        EZLButtonTableViewCell *buttonCell = (EZLButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:deleteCellIdentifier forIndexPath:indexPath];

        buttonCell.button.tintColor = Branding.shared.actionColor;
        [buttonCell.button setTitle:NSLocalizedString(@"GENERAL.REMOVE", "Remove") forState:UIControlStateNormal];
        buttonCell.delegate = self;
        
        return buttonCell;
        
    // }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 2;
    }
    
    if(section == 1) {
        return 2;
    }
    
    if (section == 2) {
        return 1;
    }
    
    return 0;
}

#pragma mark: - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    
    switch (section) {
        case 0:
            sectionName = nil;
            break;
        case 1:
            sectionName = [NSString stringWithFormat:NSLocalizedString(@"quantities", nil)];
            
        default:
            break;
    }
    
    return sectionName;
}

#pragma mark - Actions

- (IBAction)saveThingAction:(id)sender {
    [self saveProduct];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
