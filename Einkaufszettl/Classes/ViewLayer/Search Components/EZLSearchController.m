//
//  EZLSearchController.m
//  Einkaufszettl
//
//  Created by Nathan Mattes on 22.10.15.
//  Copyright © 2015 Nathan Mattes. All rights reserved.
//

#import "EZLSearchController.h"
#import "Einkaufszettl-Swift.h"

@interface EZLSearchController () {
    UISearchBar *_searchBar;
}
@end

@implementation EZLSearchController

-(UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[EZLSearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text length] > 0) {
        self.active = true;
    } else {
        self.active = false;
    }
}

@end
