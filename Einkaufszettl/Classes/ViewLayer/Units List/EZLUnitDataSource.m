//
//  EZLUnitDataSource.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 31.07.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import "EZLUnitDataSource.h"
#import "Einkaufszettl-Swift.h"

@implementation EZLUnitDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.resultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *kUnitCellIdentifier = @"UnitCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUnitCellIdentifier
                                                             forIndexPath:indexPath];
    ProductUnit *unit = [[self resultsController] objectAtIndexPath:indexPath];
    if([[self.product unit] isEqual:unit]) {
        cell.textLabel.font = [OldBranding.shared selectedItemFont];
    } else {
        cell.textLabel.font = [OldBranding.shared unselectedItemFont];
    }
    if(unit.name != nil && [[unit name] isEqualToString:@""] == false) {
        cell.textLabel.text = unit.name;
    } else {
        cell.textLabel.text = NSLocalizedString(@"no_name", nil);
    }

    return cell;
}

@end
