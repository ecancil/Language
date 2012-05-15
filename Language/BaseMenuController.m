//
//  BaseMenuController.m
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseMenuController.h"
#import "AppDelegate.h"
#import "SecondaryMenuController.h"
#import "WordsDAO.h"
#import "WordsDAOImpl.h"
#import "SecondaryListModel.h"
#import "SQLSection.h"
#import "ManagedObjectsDao.h"
#import "ChooseCreateScreen.h"
#import "PreferencesPane.h"
#import "SaveTypes.h"
#import "NotificationConstants.h"
#import "StyledTableCell.h"
#import "CreateGroup.h"
#import "CreateGroupDataSource.h"
#import "AddSectionModel.h"
#import "SpecialIdentifiers.h"
#import "AssetConstants.h"
#import "DaoInteractor.h"


@interface BaseMenuController ()
    -(void)loadPList;
-(void)setupBarOnEdit;
-(void)setupBarOnFinishEdit;
-(void)popStackedViews;
@property(nonatomic, retain) NSIndexPath *previouslySelected;
@property(nonatomic, retain) DaoInteractor *menuValuesModel;
@end

@implementation BaseMenuController
@synthesize menuValues;
@synthesize  wordsDao;
@synthesize sections;
@synthesize notificationCenter;
@synthesize tableView;
@synthesize nonUserSections;
@synthesize userSections;
@synthesize managedObjectDao;
@synthesize appDelegate;
@synthesize secondaryMenu;
@synthesize allWordBankWords;
@synthesize userCreatedwords;
@synthesize defaultWordBank;
@synthesize allWords;
@synthesize allUserWords;
@synthesize flashcardModel;
@synthesize previouslySelected;
@synthesize menuValuesModel;






- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)defaultWordsUpdated{
    if(self.menuValuesModel.completelyInitialized)[self.tableView reloadData];  
}

-(void)userCreatedWordsUpdated{
    if(self.menuValuesModel.completelyInitialized){
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        if(selectedPath.section == 1 & selectedPath.row == 1){
            [SecondaryListModel getInstance].menuValues = self.menuValuesModel.allUserCreatedWords.mutableCopy;
        }else{
            [self.tableView reloadData];
        } 
    }
}

-(void)wordBankUpdated{
    if(self.menuValuesModel.completelyInitialized){
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        if(selectedPath.section == 0 & selectedPath.row == 0){
            [SecondaryListModel getInstance].menuValues = self.menuValuesModel.defaultWordBank.wordIDs;
        }else{
            [self.tableView reloadData];
        }
    }
}

-(void)userAddedSectionsUpdated{
    if(self.menuValuesModel.completelyInitialized){
        [self.tableView reloadData];
    }
}

-(void)allInitialLoaded{
    [self performSelectorOnMainThread:@selector(setupLater) withObject:nil waitUntilDone:YES ];
}

-(void)setupLater{
    [self.tableView reloadData];
    [self setupBarOnFinishEdit];  
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
    self.previouslySelected = nil;
    
    [self.navigationController.navigationBar setBarStyle: UIStatusBarStyleBlackTranslucent];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
    
    flashcardModel = [FlashcardModel getInstance];
    
    
    [self loadPList];
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[self setupBarOnFinishEdit];
    
    
    menuValuesModel = [DaoInteractor getInstance];
    [menuValuesModel addTarget:self andSelector:@selector(defaultWordsUpdated) forMenuUpdateType:DefaultWordsUpdate];
    [menuValuesModel addTarget:self andSelector:@selector(userCreatedWordsUpdated) forMenuUpdateType:UserCreatedWordsUpdate];
    [menuValuesModel addTarget:self andSelector:@selector(allInitialLoaded) forMenuUpdateType:AllInitialLoaded];
    [menuValuesModel addTarget:self andSelector:@selector(wordBankUpdated) forMenuUpdateType:DefaultWordBankUpdate];
    [menuValuesModel addTarget:self andSelector:@selector(userAddedSectionsUpdated) forMenuUpdateType:UserCreatedSectionsUpdate];
    [menuValuesModel doInitialMenuRetrieval];


}

-(void)onSettings:(id)sender{
    [self popStackedViews];
    PreferencesPane *prefPane = [[PreferencesPane alloc] initWithNibName:@"PreferencesPane" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:prefPane];
    [self presentModalViewController:navController animated:YES];
}


-(void)loadPList{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BaseMenuLabels" ofType:@"plist"];
    
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:plistPath];
    
    NSMutableDictionary *pListDict;
    
    if(success){
        pListDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        self.menuValues = [[[NSArray alloc] initWithArray:[pListDict objectForKey:@"baseMenuLabels"]] mutableCopy];
    }else{
        NSLog(@"Issue opening plist");
    } 
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    notificationCenter = nil;
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    // Return the number of rows in the section.
    if(section == 0){
        return 1;
    }else if(section == 1){
    //This is for non user created sections + default words + user created words - comprises default study items
        return self.menuValuesModel.completelyInitialized ? self.menuValuesModel.allDefaultSections.count + 2 : 2;
    }else if(section == 2){
        //this is for user add sections
        if(self.menuValuesModel.allUserCreatedSections.count > 0){
            return self.menuValuesModel.completelyInitialized ? self.menuValuesModel.allUserCreatedSections.count : 0;
        }else{
            if (!self.menuValuesModel.completelyInitialized) {
                return 0;
            }
            [self.menuValuesModel.allUserCreatedSections addObject:@""];
            [self.tableView reloadData];
            return 0;
        }
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Word Bank";
    }else if(section == 1){
        return @"Default study items";
    }else if(section == 2){
       return @"User Sections";         
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    // Configure the cell...

    
    int row = indexPath.row;
    int section = indexPath.section;
    if(section == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@%d%@", self.menuValuesModel.defaultWordBank.title, @"(", self.menuValuesModel.defaultWordBank.wordIDs.count, @")"];
        //[flashcardModel getPercentCorrectFromArrayOfWords:defaultWordBank.words.allObjects withCell:cell];
        cell.imageView.image = WORDBANK_ASSET;
    }
    if(section == 1){
        if(row == 0){
            NSString *textValue = (NSString *)[menuValues objectAtIndex:row];
            int total = self.menuValuesModel.allDefaultWords.count;
            cell.textLabel.text = [textValue stringByAppendingString:[NSString stringWithFormat:@" %@%d%@", @"(", total, @")"]]; 
            //[flashcardModel getPercentCorrectFromArrayOfWords:allWords withCell:cell];
            cell.imageView.image = DEFAULT_WORDS_ASSET;
        }else if(row == 1){
            NSString *textValue = (NSString *)[menuValues objectAtIndex:row];
            int total = self.menuValuesModel.allUserCreatedWords.count;
            cell.textLabel.text = [textValue stringByAppendingString:[NSString stringWithFormat:@" %@%d%@", @"(", total, @")"]];
            //[flashcardModel getPercentCorrectFromArrayOfWords:allUserWords withCell:cell];
            cell.imageView.image = USER_ADDED_ASSET; 
        }else{
            SQLSection *section = [self.menuValuesModel getDefaultSectionByIndex:row - 2];
            NSString *textValue = [NSString stringWithFormat:@"%@ ", section.title];
            int total = section.words.count;
            textValue = [textValue stringByAppendingString:[NSString stringWithFormat:@" %@%d%@", @"(", total, @")"]];
            cell.textLabel.text = textValue;
            //[flashcardModel getPercentCorrectFromArrayOfWords:nonUserSectionWords withCell:cell];
            cell.imageView.image = DEFAULT_WORDS_ASSET; 
        }
    }
    if(section == 2){
        cell.imageView.image = USER_ADDED_ASSET;
        if(self.menuValuesModel.allUserCreatedSections.count == 1 && [[self.menuValuesModel.allUserCreatedSections objectAtIndex:0] isKindOfClass:[NSString class]]){
            cell.textLabel.text = @"No sections - add one";
            [cell hideProgress];
            return cell;
        }else{
            Section *section = (Section *)[self.menuValuesModel getUserCreatedSectionByIndex:row];
            if(section)cell.textLabel.text = section.title;  
            //[flashcardModel getPercentCorrectFromArrayOfWords:section.words.allObjects withCell:cell];
        }
    }
       [cell showProgress];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    self.previouslySelected = indexPath;
    SecondaryListModel *model = [SecondaryListModel getInstance];
    int row = indexPath.row;
    int section = indexPath.section;
    if(section == 0){
        //these are the word bank words
        model.menuValues = self.menuValuesModel.defaultWordBank.wordIDs;
        model.activeUserSection = self.menuValuesModel.defaultWordBank;
    }else if(section == 1){
        model.activeUserSection = nil;
        if(row == 0){
            //these are the default words that ship with the program
            model.menuValues = menuValuesModel.allDefaultWords.copy;
        }else if(row == 1){
            //these are all the words the user has created
            model.menuValues = self.menuValuesModel.allUserCreatedWords.mutableCopy;
            model.activeUserSection = self.menuValuesModel.defaultUserCreatedWordsSection;
        }else{
            SQLSection *section = [self.menuValuesModel getDefaultSectionByIndex:row - 2];
            model.menuValues = section.words.mutableCopy;
        }  
    }else{
        //Here we're going to deal with user created sections
        if([self.menuValuesModel.allUserCreatedSections count] == 1 && [[self.menuValuesModel.allUserCreatedSections objectAtIndex:0] isKindOfClass:[NSString class]]){
            [self popStackedViews];
            
            secondaryMenu = nil;
            
            CreateGroup *createGroupScreen = [[CreateGroup alloc] initWithFormDataSource:[[CreateGroupDataSource alloc] initWithModel:[AddSectionModel getInstance]]];
            
            [[self navigationController] pushViewController:createGroupScreen animated:YES];
            return;
 
        }else{
            Section *section = (Section *)[self.menuValuesModel getUserCreatedSectionByIndex:row];
            model.menuValues = section.wordIDs;
            model.activeUserSection = section;
        }
        
        
    }
    

    if(secondaryMenu != Nil){
        
    }else{
        secondaryMenu = [[SecondaryMenuController alloc] initWithNibName:@"SecondaryMenuController" bundle:nil];
        secondaryMenu.popNavigationDelegate = self;
        UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:secondaryMenu];
        
        [[appDelegate stackedController] pushViewController:navigator animated:YES];
        [[appDelegate stackedController] expandStack:1 animated:YES]; 
    }
    
    [[appDelegate stackedController] collapseStack:1 animated:YES];
    
 }

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2)return YES;
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Section *section = (Section *)[self.menuValuesModel getUserCreatedSectionByIndex:indexPath.row];
    [self.menuValuesModel eraseUserCreatedSection:section];
    [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}

- (IBAction)add:(id)sender {
    
    [self popStackedViews];
    
    secondaryMenu = nil;
    
     ChooseCreateScreen *chooseScreen = [[ChooseCreateScreen alloc] initWithNibName:@"ChooseCreateScreen" bundle:nil];

    [[self navigationController] pushViewController:chooseScreen animated:YES];
    

}

-(void)onEdit:(id)sender{
    [self popStackedViews];
    [self setupBarOnEdit];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}

-(void)onFinishEdit:(id)sender{
    [self setupBarOnFinishEdit];
}

-(void)setupBarOnEdit{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onFinishEdit:)];
    

    UIBarButtonItem *preferencesButton = [[UIBarButtonItem alloc] initWithImage:PREFERENCES_ASSET style:UIBarButtonItemStyleBordered target:self action:@selector(onSettings:)];
    
    if(self.menuValuesModel.allUserCreatedSections && self.menuValuesModel.allUserCreatedSections.count > 0 && ![[self.menuValuesModel.allUserCreatedSections objectAtIndex:0] isKindOfClass:[NSString class]]){
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:addButton, editButton, preferencesButton, nil] animated:YES];
        
        [self.tableView setEditing:YES animated:YES];
    }else{
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:addButton, preferencesButton, nil] animated:YES];
        
        [self.tableView setEditing:YES animated:YES];
    }
}
-(void)setupBarOnFinishEdit{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit:)];
    

    UIBarButtonItem *preferencesButton = [[UIBarButtonItem alloc] initWithImage:PREFERENCES_ASSET style:UIBarButtonItemStyleBordered target:self action:@selector(onSettings:)];
    
    if(self.menuValuesModel.allUserCreatedSections && self.menuValuesModel.allUserCreatedSections.count > 0 && ![[self.menuValuesModel.allUserCreatedSections objectAtIndex:0] isKindOfClass:[NSString class]]){
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:addButton, editButton, preferencesButton, nil] animated:YES];
        
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:addButton, preferencesButton, nil] animated:YES];
        
        [self.tableView setEditing:NO animated:YES];
    }
}

-(void)popStackedViews{
    secondaryMenu = nil;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    while (appDelegate.stackedController.viewControllers.count > 0) {
        [appDelegate.stackedController popViewControllerAnimated:YES];
    }
    [appDelegate.stackedController setLeftInset:50];
}
@end