//
//  AddWordsToGroup.m
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddWordsToGroup.h"
#import "SQLWord.h"
#import "RomanjiToHiragana.h"
#import "SaveTypes.h"
#import "AddSectionModel.h"
#import "StyledTableCell.h"

@interface AddWordsToGroup ()
    -(void)removeAddedWords;
    -(void)applySearch:(NSString *)searchString;
    -(void)setWOrdsArrays;
@property (nonatomic, retain) AddSectionModel *model;
@end

@implementation AddWordsToGroup
@synthesize tableView;
@synthesize searchBar;
@synthesize wordsDao;
@synthesize moDao;
@synthesize sectionToBeSaved;
@synthesize searchController;
@synthesize addedWordsTable;
@synthesize allWords;
@synthesize visibleWords;
@synthesize addedWordsTableDelegate;
@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [AddSectionModel getInstance];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchController setSearchResultsDelegate:self];
    [self.searchController setSearchResultsDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.searchController setDelegate:self];
    
    
    addedWordsTableDelegate = [[AddedWordsTableDelegate alloc] initWithTable:self.addedWordsTable];
    wordsDao = [[WordsDAOImpl alloc] initWithDatabasePath:@"words.sqlite"];
    moDao = [ManagedObjectsDao getInstance];
    
    
    [self setWOrdsArrays];
    [tableView reloadData];

    
    //[self.searchBar 

    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removedWord:) name:@"Removed_Added_Word" object:nil];
    
    UIBarButtonItem *saveGroupButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveGroupButton, nil] animated:YES];
    
}

-(void)setWOrdsArrays{
    allWords = visibleWords = [self.daoInteractor.allUserCreatedSections arrayByAddingObjectsFromArray:self.daoInteractor.allDefaultWords].mutableCopy;

}

-(void)save:(id)sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wasSaved:) name:USER_SECTION_SAVED object:nil];
    [self.daoInteractor addNewSectionByTitle:model.sectionName withWords:addedWordsTableDelegate.addedWords];
}

-(void)wasSaved:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)addWords:(id)sender{
    AddWordsToGroup *add = [[AddWordsToGroup alloc] initWithNibName:@"AddWordsToGroup" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}

-(void)removedWord:(id)sender{
    NSNotification *notification = (NSNotification *)sender;
    SQLWord *wordToAdd = (SQLWord *)[notification.userInfo objectForKey:@"removedWord"];
    [self setWOrdsArrays];
    NSString *searchTerm = [searchBar text];
    if(searchTerm){
        [self applySearch:searchTerm];
    }
    [self.tableView reloadData];
    [self.searchController.searchResultsTableView reloadData];
    
    [self removeAddedWords];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setAddedWordsTable:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [visibleWords count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    //static NSString *CellIdentifier = @"DefaultGradientCell";
    
    StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //DefaultGradientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell = [[DefaultGradientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    
    int row = indexPath.row;
    if(row > [visibleWords count])return cell;
    Word *word = [self getWordFromCollection:visibleWords ByRow:row];
    
    if (word) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = word.language1;
        cell.detailTextLabel.text = word.language2;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark search stuff
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self applySearch:searchString];
    return YES;
}

-(void)applySearch:(NSString *)searchString{
    RomanjiToHiragana *r2h = [[RomanjiToHiragana alloc] init];
    NSString *kana = [r2h romanjiToKana:searchString];
    visibleWords = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < [allWords count]; i ++) {
        SQLWord *word = [allWords objectAtIndex:i];
        if(word){
            if([word.language1 rangeOfString:searchString].location != NSNotFound
               || [word.language2 rangeOfString:searchString].location != NSNotFound
               || [word.language2supplemental rangeOfString:searchString].location != NSNotFound
               || [word.language2 rangeOfString:kana].location != NSNotFound
               || [word.language2supplemental rangeOfString:kana].location!= NSNotFound
               || [word.language2supplemental rangeOfString:kana].location != NSNotFound){
                [visibleWords addObject:word];
            }
        }
    }
    [self removeAddedWords];
    [tableView reloadData];
}

- (void) searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)searchTableView{
   [searchTableView setFrame:self.tableView.frame]; 
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)searchTableView{
    [searchTableView setFrame:self.tableView.frame];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)removedTableView{
    [self setWOrdsArrays];
    [tableView reloadData];
    [removedTableView reloadData];
    [self removeAddedWords];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    SQLWord *word = [visibleWords objectAtIndex:row];
    [addedWordsTableDelegate addWord:word];
    [self removeAddedWords];
}

-(void)removeAddedWords{
    int i;
    int j;
    for (i = [visibleWords count] - 1; i > -1; i --) {
        SQLWord *wordOne = [visibleWords objectAtIndex:i];
        for (j = 0; j < [[addedWordsTableDelegate addedWords] count]; j ++) {
            SQLWord *wordTwo = [addedWordsTableDelegate.addedWords objectAtIndex:j];
            if(wordOne == wordTwo){
                NSLog(@"%d", j);
                [visibleWords removeObject:wordOne];
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
                if(searchController.searchResultsTableView){
                    [searchController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
                }

            }
        }
    }
}

@end
