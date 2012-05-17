//
//  WordsFromImport.m
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WordsFromImport.h"
#import "StyledTableCell.h"
#import "SQLWord.h"
#import "GoogleImportModel.h"
#import "AddWordModel.h"
#import "CreateWord.h"
#import "CreateWordDataSource.h"
#import "ManagedObjectsDao.h"
#import "SaveTypes.h"
#import "StyledTableCellConstants.h"
#import "UACellBackgroundView.h"
#import "AssetConstants.h"
@interface WordsFromImport ()
@property (nonatomic, retain) GoogleImportModel *importModel;
@property (nonatomic, retain) AddWordModel *addWordModel;
@property (nonatomic, retain) ManagedObjectsDao *moDao;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, assign) double saveIndex;
@property (nonatomic, assign) BOOL startedSave;
-(void)makeOneEntry;
-(void)showProgress;
-(void)hideProgressAndPerformSelector:(SEL)selector;
-(void)updateProgress:(NSNumber *)progress;

@end
@implementation WordsFromImport
@synthesize tableView;
@synthesize importModel;
@synthesize addWordModel;
@synthesize moDao;
@synthesize progressView;
@synthesize saveIndex;
@synthesize startedSave;

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
    
    self.startedSave = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finalWordAdded:) name:WORD_SAVED object:moDao];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonFinalWordAdded:) name:GOOGLE_WORD_SAVED object:moDao];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];

    
    importModel = [GoogleImportModel getInstance];
    addWordModel = [AddWordModel getInstance];
    moDao = [ManagedObjectsDao getInstance];
    
    if(importModel.words.count > 0){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit:)];
        UIBarButtonItem *saveAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveAll:)];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveAllButton, editButton, nil]];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)onEdit:(id)sender{
    [self.tableView setEditing:YES animated:YES];
    if(importModel.words.count > 0){
        UIBarButtonItem *doneEditing = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onEditDone:)];
        UIBarButtonItem *saveAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveAll:)];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveAllButton, doneEditing, nil]];
    }
}

-(void)onEditDone:(id)sender{
    [self.tableView setEditing:NO animated:YES];
    if(importModel.words.count > 0){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit:)];
        UIBarButtonItem *saveAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveAll:)];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveAllButton, editButton, nil]];
    }
}

-(void)onSaveAll:(id)sender{
    self.saveIndex = 0;
    self.startedSave = YES;
    [self.tableView reloadData];
    [self showProgress];
    [self makeOneEntry];
}

-(void)makeOneEntry{
    SQLWord *word = (SQLWord *)[importModel.words objectAtIndex:saveIndex];   
    
    if(saveIndex == importModel.words.count - 1){
        //[moDao addUserCreatedWordWithLanguage1:word.language1 andLanguage2:word.language2 andlanguage2supplemental:word.language2supplemental andExampleSentences:word.examples andImage:word.image createOnly:NO];
        [self.daoInteractor addUserCreatedWordWithLanguage1:word.language1 andLanguage2:word.language2 andlanguage2supplemental:word.language2supplemental andExampleSentences:word.examples andImage:word.image createOnly:NO];
    }else{
        [self.daoInteractor addUserCreatedWordWithLanguage1:word.language1 andLanguage2:word.language2 andlanguage2supplemental:word.language2supplemental andExampleSentences:word.examples andImage:word.image createOnly:YES];
        //[moDao addUserCreatedWordWithLanguage1:word.language1 andLanguage2:word.language2 andlanguage2supplemental:word.language2supplemental andExampleSentences:word.examples andImage:word.image createOnly:YES];
    }
}

-(void)finalWordAdded:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        saveIndex ++;
        [self performSelectorOnMainThread:@selector(popToMain) withObject:nil waitUntilDone:NO];
    });
   // [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)nonFinalWordAdded:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        saveIndex ++;
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithDouble:(double)saveIndex / (double)importModel.words.count] waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(scrollToCell:) withObject:[NSNumber numberWithInt:(int)saveIndex] waitUntilDone:NO];
        //[self makeOneEntry];
        [self performSelectorOnMainThread:@selector(makeOneEntry) withObject:nil waitUntilDone:NO];
        //[self updateProgress:[NSNumber numberWithDouble:(double)saveIndex / (double)importModel.words.count]];
    });
}


         
-(void)popToMain{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)updateProgress:(NSNumber *)progress{
    //NSLog(@"Progress %fl", progress.doubleValue);
    [progressView setProgress:(progress.doubleValue) animated:YES];
}

-(void)scrollToCell:(NSNumber *)cell{
    NSIndexPath *path = [NSIndexPath indexPathForRow:cell.intValue inSection:0];
    if(cell.intValue > 0){
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:cell.intValue - 1 inSection:0];
        SQLWord *previousWord = [importModel.words objectAtIndex:cell.intValue - 1];
        UITableViewCell *thePreviousCell = [self.tableView cellForRowAtIndexPath:previousPath];
        thePreviousCell.textLabel.text = previousWord.language1;
        thePreviousCell.backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero andType:BACKGROUND_NOT_SELECTED_TYPE];
        thePreviousCell.imageView.image = USER_ADDED_ASSET;
    }
    UITableViewCell *theCell = [self.tableView cellForRowAtIndexPath:path];
    SQLWord *word = [importModel.words objectAtIndex:cell.intValue];
    theCell.textLabel.text = [word.language1 stringByAppendingString:@" (Currently Saving)"];
    theCell.backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero andType:BACKGROUND_RED_TYPE];
    theCell.imageView.image = SAVING_ASSET;
    NSIndexPath *nextPath = [NSIndexPath indexPathForRow:cell.intValue + 6 inSection:0];
    if(cell.intValue + 6 < self.importModel.words.count)[self.tableView scrollToRowAtIndexPath:nextPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

-(void)showProgress{
    [self.navigationItem setRightBarButtonItems:[[NSArray alloc]init]];
    [self.navigationItem setHidesBackButton:YES];
   progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressView setProgress:0 animated:NO];
  [self.navigationItem setTitleView:progressView];
  [UIView animateWithDuration:.4 animations:^{
      [progressView setAlpha:1];
  }];  
}
-(void)hideProgressAndPerformSelector:(SEL)selector{
    [UIView animateWithDuration:.4 animations:^{
        [progressView setAlpha:1];
    } completion:^(BOOL finished) {
        if(selector != nil)[self performSelector:selector withObject:nil afterDelay:.5];
    }];   
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return importModel.words.count == 0 ? 3 : [importModel.words count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    int row = indexPath.row;
    cell.imageView.image = USER_ADDED_ASSET;
    if (importModel.words.count == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NOWORDS"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (row == 2) {
            CGRect frame = cell.frame;
            frame.size.width = cell.frame.size.width;
            [cell setFrame:frame];
            cell.textLabel.text = @"There were no valid words";
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        }
    }else{
        SQLWord *word = [importModel.words objectAtIndex:row];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = word.language1;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   (%@)", word.language2, word.language2supplemental];
        if(self.startedSave){
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }
    return cell;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [addWordModel clear];
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (importModel.words.count == 0)return;
    int row = indexPath.row;
     SQLWord *word = [importModel.words objectAtIndex:row];
    [addWordModel updateValuesWithWord:word];
    CreateWord *editWord = [[CreateWord alloc] initEditorWithFormDataSource:[[CreateWordDataSource alloc] initWithModel:addWordModel] andIsEditor:YES];
    [self.navigationController pushViewController:editWord animated:YES];

    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    [importModel.words removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
