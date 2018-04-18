//
//  EZLCategoryDetailTableViewController.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 21.10.15.
//  Copyright © 2015 Nathan Mattes. All rights reserved.
//

#import "EZLCategoryDetailTableViewController.h"
#import "Einkaufszettl-Swift.h"

@interface EZLCategoryDetailTableViewController ()

@end

@implementation EZLCategoryDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[EZLCategoryDetailDataSource alloc] initWithCategory:self.category managedObjectContext:self.managedObjectContext buttonCellDelegate:self];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.title = self.category.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [[(DetailCellWithTextField *)[self.tableView cellForRowAtIndexPath:firstRow] detailTextField] becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)saveThingCategory:(id)sender
{
    NSError *error;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString *name = [[self.tableView cellForRowAtIndexPath:indexPath] detailTextField].text;
    self.category.name = name;
    
    if([self.managedObjectContext save:&error] == NO) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

@end
