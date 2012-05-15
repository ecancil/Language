//
//  AddWordsToGroup.h
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WordsDAOImpl.h"
#import "ManagedObjectsDao.h"
#import "Section.h"
#import "AddedWordsTableDelegate.h"
#import "BaseViewController.h"

@interface AddWordsToGroup : BaseViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    WordsDAOImpl *wordsDao;
    ManagedObjectsDao *moDao;
    Section *sectionToBeSaved;
    UISearchDisplayController *searchController;
    NSArray *allWords;
    NSMutableArray *visibleWords;
    AddedWordsTableDelegate *addedWordsTableDelegate;
    NSString *title;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *allWords;
@property(strong, nonatomic) NSMutableArray *visibleWords;
@property(strong, nonatomic) WordsDAOImpl *wordsDao;
@property(strong, nonatomic) ManagedObjectsDao *moDao;
@property(strong, nonatomic) Section *sectionToBeSaved;
@property(strong, nonatomic) UISearchDisplayController *searchController;
@property(strong, nonatomic) AddedWordsTableDelegate *addedWordsTableDelegate;
@property (strong, nonatomic) IBOutlet UITableView *addedWordsTable;
@property(strong, nonatomic) NSString *title;


@end
