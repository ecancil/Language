//
//  SecondaryMenuController.m
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondaryMenuController.h"
#import "SecondaryListStates.h"
#import "SecondaryListModel.h"
#import "SQLWord.h"
#import "AppDelegate.h"
#import "WordView.h"
#import "RomanjiToHiragana.h"
#import "DefaultGradientCell.h"
#import "ManagedObjectsDao.h"
#import "FlashCard.h"
#import "StyledTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FlashcardModel.h"
#import "NotificationConstants.h"
#import "SpecialIdentifiers.h"
#import "AssetConstants.h"
#import "SaveTypes.h"
#import "WordCache.h"

@interface SecondaryMenuController ()
-(void)determineData;
@property (nonatomic, retain) WordView *wordView;
-(Word *)getWordByRow:(int)row;
-(void)removeObjectFromArrayByWord:(Word *)word;
@end
@implementation SecondaryMenuController

@synthesize state;
@synthesize searchController;
@synthesize tableView;
@synthesize searchBar;
@synthesize visibleItems;
@synthesize popNavigationDelegate;
@synthesize wordView;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(Word *)getWordByRow:(int)row{
    return [super getWordFromCollection:self.visibleItems ByRow:row];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    state = all;
    
    [self.navigationController.navigationBar setBarStyle: UIStatusBarStyleBlackTranslucent];
    [self.searchBar setBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    SecondaryListModel *model = [SecondaryListModel getInstance];
    [model addObserver:self forKeyPath:@"menuValues" options:NSKeyValueObservingOptionNew context:NULL];
    [model addObserver:self forKeyPath:@"activeUserSection" options:NSKeyValueObservingOptionNew context:NULL];
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    [searchController setDelegate:self];
    [searchController setSearchResultsDataSource:self];
    [searchBar setDelegate:self];
    
    [self determineData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPrevious:) name:PREVIOUS_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNext:) name:NEXT_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordAdded:) name:WORD_SAVED object:nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)setFirstSelected{
    if([self.tableView isEditing] && self.visibleItems.count > 0)return;
    if(self.visibleItems.count == 0){
        [self.popNavigationDelegate popStackedViews];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void) wordAdded:(NSNotification *) notificatio{
    [self.tableView reloadData];
}

- (void) onPrevious:(NSNotification *) notification{
    NSIndexPath *currentIndex = [self.tableView indexPathForSelectedRow];
    if(currentIndex.row - 1 == -1)return;
    NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:currentIndex.row - 1 inSection:currentIndex.section];
    [self.tableView selectRowAtIndexPath:previousIndex animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self tableView:self.tableView didSelectRowAtIndexPath:previousIndex];
}
- (void) onNext:(NSNotification *) notification{
    NSIndexPath *currentIndex = [self.tableView indexPathForSelectedRow];
    if(currentIndex.row + 1 >= [self.visibleItems count])return;
    NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:currentIndex.row + 1 inSection:currentIndex.section];
    [self.tableView selectRowAtIndexPath:nextIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:nextIndex];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self determineData];
    [self.tableView setEditing:NO animated:YES];
    if(visibleItems.count == 0){
        [self setFirstSelected];
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.stackedController setLeftInset:50 animated:YES];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void)determineData{
    
    visibleItems = [[[SecondaryListModel getInstance] menuValues] mutableCopy];
    [self.searchController setActive:NO animated:YES];
    [self.tableView reloadData];
    Section *activeUserSection = [[SecondaryListModel getInstance] activeUserSection];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    UIBarButtonItem *studyButton = [[UIBarButtonItem alloc] initWithImage:FLASHCARD_ASSET style:UIBarButtonItemStylePlain target:self action:@selector(study:)];
    NSString *si = activeUserSection.specialIdentifier;
    if(([activeUserSection.specialIdentifier isEqualToString:USER_CREATED] && activeUserSection.wordIDs.count > 0)
        || ([activeUserSection.specialIdentifier isEqualToString:ALL_USER_CREATED_WORDS])
        || ([activeUserSection.specialIdentifier isEqualToString:WORD_BANK] && activeUserSection.wordIDs.count > 0)
        ){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit:)];
//        [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:closeButton, editButton, studyButton, nil] animated:YES];
    }else{
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: closeButton, studyButton, nil] animated:YES];
    }
     
}

-(void)onClose:(id)sender{
    [self.popNavigationDelegate popStackedViews];
    
}

-(void)onEdit:(id)sender{
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *completeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onEditComplete:)];
        UIBarButtonItem *studyButton = [[UIBarButtonItem alloc] initWithImage:FLASHCARD_ASSET style:UIBarButtonItemStylePlain target:self action:@selector(study:)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:closeButton, completeButton, studyButton, nil] animated:YES];

}

-(void)onEditComplete:(id)sender{
    [self.tableView setEditing:NO animated:YES];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit:)];
        UIBarButtonItem *studyButton = [[UIBarButtonItem alloc] initWithImage:FLASHCARD_ASSET style:UIBarButtonItemStylePlain target:self action:@selector(study:)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:closeButton, editButton, studyButton, nil] animated:YES];

}

-(void)study:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      while(appDelegate.stackedController.viewControllers.count > 1) {
        [appDelegate.stackedController popViewControllerAnimated:YES];
    }
    [appDelegate.stackedController setLeftInset:50 animated:YES];
    //[self performSelector:@selector(popUpStudy) withObject:self afterDelay:.5];
    //FlashCard *flashCard = [[FlashCard alloc] initWithNibName:@"FlashCard" bundle:nil];
    SecondaryListModel *model = [SecondaryListModel getInstance];
    FlashCard *flashCard = [[FlashCard alloc] initWithFlashcardWords:model.menuValues];
    [appDelegate.stackedController presentModalViewController:flashCard animated:YES];
}

-(void)popUpStudy{
    SecondaryListModel *model = [SecondaryListModel getInstance];
    //FlashCard *flashCard = [[FlashCard alloc] initWithNibName:@"FlashCard" bundle:nil];
    FlashCard *flashCard = [[FlashCard alloc] initWithFlashcardWords:model.menuValues];
    [self presentModalViewController:flashCard animated:YES];
  
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setSearchBar:nil];
    [self setSearchBar:nil];
    [self setTableView:nil];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [[SecondaryListModel getInstance] removeObserver:self forKeyPath:@"menuValues"];
    [[SecondaryListModel getInstance] removeObserver:self forKeyPath:@"activeUserSection"];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [[self view]setFrame:CGRectMake(0, 0, screenRect.size.width + 50, screenRect.size.height)];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [visibleItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //static NSString *CellIdentifier = @"DefaultGradientCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    /*tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.bounds;*/

    //gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    //[cell.layer insertSublayer:gradient above:0];

    
    
    int row = indexPath.row;
    if(row > [visibleItems count] - 1 || visibleItems.count == 0)return cell;
    
    
    Word *word = [self getWordByRow:row];
    
    
    if (word) {
        FlashcardModel *fcm = [FlashcardModel getInstance];
        if([fcm knowsWord:word]){
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:KNOWN_WORD_ASSET]];
        }else{
            [cell setAccessoryView:nil];
        }
        cell.textLabel.text = word.language1;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   (%@)", word.language2, word.language2supplemental];
    }
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SecondaryListModel *model = [SecondaryListModel getInstance];
    int row = indexPath.row;
    int count = appDelegate.stackedController.viewControllers.count;
    SQLWord * selectedWord = [visibleItems objectAtIndex:row];
    if(count == 1){
        wordView = [[WordView alloc] initWithNibName:@"WordView" bundle:nil];
        UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:wordView];
        [appDelegate.stackedController pushViewController:navigator animated:YES];
        wordView.theWord = [self getWordByRow:row];
    }else{
        wordView.theWord = [self getWordByRow:row];
    }
    
    [appDelegate.stackedController setLeftInset:0 animated:YES];
    int i = 0;
    while(i < count){
        [appDelegate.stackedController collapseStack:i animated:YES];
        i ++;
    }
    
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqualToString:@""]){
        visibleItems = [[[SecondaryListModel getInstance] menuValues] mutableCopy];
    }
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; 
    UIViewController *lastController = [appDelegate.stackedController.viewControllers objectAtIndex:[appDelegate.stackedController.viewControllers count] -1];
    
    //if([lastController isKindOfClass:[WordView class]])[appDelegate.stackedController expandStack:[appDelegate.stackedController.viewControllers count] - 1 animated:YES];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    [tableView setDelegate:self];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
    SecondaryListModel *model = [SecondaryListModel getInstance];
    RomanjiToHiragana *r2h = [[RomanjiToHiragana alloc] init];
    NSString *kana = [r2h romanjiToKana:searchString];
    int i = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (i; i < model.menuValues.count; i ++) {
        SQLWord *word = (SQLWord *)[model.menuValues objectAtIndex:i];
        if([word.language1 rangeOfString:searchString].location != NSNotFound
           || [word.language2 rangeOfString:searchString].location != NSNotFound
           || [word.language2supplemental rangeOfString:searchString].location != NSNotFound
           || [word.language2 rangeOfString:kana].location != NSNotFound
           || [word.language2supplemental rangeOfString:kana].location!= NSNotFound
           || [word.language2supplemental rangeOfString:kana].location != NSNotFound){
            [arr addObject:word];
        }
        
    }
    visibleItems = [arr mutableCopy];
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondaryListModel *model = [SecondaryListModel getInstance];
    int count;
    count = model.menuValues.count;
    Word *word = [self getWordByRow:indexPath.row];
    if ([model.activeUserSection.specialIdentifier isEqualToString:USER_CREATED]) { 
        [self removeObjectFromArrayByWord:word];
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.daoInteractor removeWord:word fromUserCreatedSection:model.activeUserSection];
    }else if([model.activeUserSection.specialIdentifier isEqualToString:WORD_BANK]){
        [self removeObjectFromArrayByWord:word];
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.daoInteractor removeWordFromDefaultWordBank:word];
    }else if([model.activeUserSection.specialIdentifier isEqualToString:ALL_USER_CREATED_WORDS]){
        [self removeObjectFromArrayByWord:word];
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.daoInteractor removeUserCreatedWord:word];
    }
}

-(void)removeObjectFromArrayByWord:(Word *)word{
    int i = 0;
    int count = visibleItems.count;
    for (i; i < count; i ++) {
        id foundItem = [visibleItems objectAtIndex:i];
        if ([foundItem respondsToSelector:@selector(doubleValue)]) {
            NSNumber *foundNumber = [visibleItems objectAtIndex:i];
            double foundDouble = foundNumber.doubleValue;
            if(foundDouble == word.uniqueID.doubleValue){
                [visibleItems removeObjectAtIndex:i];
                break;
            }
        }else{
            Word *foundWord = (Word *)[visibleItems   objectAtIndex:i];
            if(foundWord.uniqueID.doubleValue == word.uniqueID.doubleValue){
                [visibleItems removeObjectAtIndex:i];
                break;
            }
        }
        
    }
}

@end
