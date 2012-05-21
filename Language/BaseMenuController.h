//
//  BaseMenuController.h
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordsDAO.h"
#import "WordsDAOImpl.h"
#import "ManagedObjectsDao.h"
#import "AppDelegate.h"
#import "SecondaryMenuController.h"
#import "Section.h"
#import "FlashcardModel.h"
#import "PopNavigationDelegate.h"
#import "BaseViewController.h"

@interface BaseMenuController : BaseViewController <UITableViewDelegate, UITableViewDataSource, PopNavigationDelegate>{
    NSMutableArray *menuValues;
    WordsDAOImpl *wordsDao;
    ManagedObjectsDao *managedObjectDao;
    NSMutableArray *userSections;
    NSArray *nonUserSections;
    NSArray *sections;
    NSNotificationCenter *notificationCenter;
    AppDelegate *appDelegate;
    SecondaryMenuController *secondaryMenu;
}
@property (nonatomic, retain) NSMutableArray *menuValues;
@property (nonatomic, retain) WordsDAOImpl *wordsDao;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSNotificationCenter *notificationCenter;
@property (nonatomic, retain) SecondaryMenuController *secondaryMenu;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ManagedObjectsDao *managedObjectDao;

@property(nonatomic, retain) FlashcardModel *flashcardModel;

- (IBAction)onAddGroup:(id)sender;
@end
