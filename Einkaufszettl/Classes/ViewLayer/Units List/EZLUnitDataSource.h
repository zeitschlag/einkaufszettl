//
//  EZLUnitDataSource.h
//  Einkaufszettl
//
//  Created by Nathan Mattes on 31.07.15.
//  Copyright (c) 2015 Nathan Mattes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// -> http://stackoverflow.com/questions/7896440/objective-c-header-file-not-recognizing-custom-object-as-a-type
@class Product;

@interface EZLUnitDataSource : NSObject <UITableViewDataSource>

@property NSFetchedResultsController *resultsController;
@property UIColor *tintColor;

@property Product *product;

@end
