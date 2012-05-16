//
//  SecondaryMenuController.h
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopNavigationDelegate.h"
#import "BaseViewController.h"
#import "AddedFlashcardDelegate.h"

@interface SecondaryMenuController : BaseViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource , AddedFlashcardDelegate>{
    NSString *state;
    UISearchDisplayController *searchController;
    NSMutableArray *visibleItems;
}
@property(nonatomic, retain) id<PopNavigationDelegate> popNavigationDelegate;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) UISearchDisplayController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
-(void)setFirstSelected;

@property (nonatomic, retain) NSMutableArray *visibleItems;
@end

