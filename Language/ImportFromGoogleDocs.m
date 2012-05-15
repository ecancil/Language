//
//  ImportFromGoogleDocs.m
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportFromGoogleDocs.h"
#import "StyledTableCell.h"
#import "GDataEntrySpreadsheet.h"
#import <QuartzCore/QuartzCore.h>
#import "GDataEntryWorksheet.h"
#import "GDataEntrySpreadsheetList.h"
#import "GDataSpreadsheetCustomElement.h"
#import "GoogleImportModel.h"
#import "LocalizationStringConstants.h"
#import "WordsFromImport.h"
#import "KeychainUtil.h"
#import "AssetConstants.h"

@interface ImportFromGoogleDocs ()
@property(nonatomic, retain) NSArray *spreadsheets;
@property(nonatomic, assign) CGRect originalRect;
-(void)isLoading;
-(void)finishedLoadingPerformSelector:(SEL)selector;
@end
@implementation ImportFromGoogleDocs
@synthesize dao;
@synthesize tableView;
@synthesize activityIndicator;
@synthesize spreadsheets;
@synthesize originalRect;

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
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self.activityIndicator startAnimating];
    originalRect = tableView.frame;

    
    NSString *email = [KeychainUtil load:@"email"];
    NSString *password = [KeychainUtil load:@"password"];
    
    dao = [[GoogleDocsDao alloc] initWithResponder:self andUsername:email andPassword:password];
    [dao fetchFeedOfSpreadsheets];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didFetchSpreadsheets:(NSArray *)theSpreadsheets{
    self.spreadsheets = theSpreadsheets.copy;
    //NSLog(@"%d", theSpreadsheets.count);
    [self.tableView reloadData];
    [self finishedLoadingPerformSelector:nil];
}
-(void)didFetchWorksheets:(NSArray *)worksheets{
    GDataEntryWorksheet *ws = (GDataEntryWorksheet *)[worksheets objectAtIndex:0];
    [self.dao fetchWorksheet:ws];
}
-(void)didFetchEntries:(NSArray *)entries{
    [self isLoading];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        int i = 0;
        int count = entries.count;
        [[GoogleImportModel getInstance] setWords:[[NSMutableArray alloc] init]];
        for (i; i < count; i ++) {
            GDataEntrySpreadsheetList *list = (GDataEntrySpreadsheetList *)[entries objectAtIndex:i];
            NSDictionary *customElements = [list customElementDictionary];
        
        
            NSEnumerator *enumerator = [customElements objectEnumerator];
            GDataSpreadsheetCustomElement *element;
            NSMutableDictionary *valueDict = [[NSMutableDictionary alloc] init];
        
            while ((element = [enumerator nextObject]) != nil) {
            //NSString *elemStr = [NSString stringWithFormat:@"(%@, %@)",
                                 //[element name], [element stringValue]];
            
                NSString *elementName = [element.name lowercaseString];
                NSString *elementValue = element.stringValue;

                [valueDict setValue:elementValue forKey:elementName];
            }
            NSString *languageOneColumnName = NSLocalizedString(LANGUAGE_ONE_COLUMN_NAME, nil);
            NSString *languageTwoColumnName = NSLocalizedString(LANGUAGE_TWO_COLUMN_NAME, nil);
            NSString *languageTwoSupplementalColumnName = NSLocalizedString(LANGUAGE_TWO_SUPPLEMENTAL_COLUMN_NAME, nil);        
            NSString *examplesColumnName = NSLocalizedString(EXAMPLES_COLUMN_NAME, nil);
        
        [[GoogleImportModel getInstance] addWordWithLanguage1:[valueDict valueForKey:languageOneColumnName] language2:[valueDict valueForKey:languageTwoColumnName] langauge2Supplemental:[valueDict valueForKey:languageTwoSupplementalColumnName] examples:[valueDict valueForKey:examplesColumnName]];
            
        }
        [self performSelectorOnMainThread:@selector(madeAllWords) withObject:nil waitUntilDone:TRUE];
    });
}

-(void)madeAllWords{
    [self finishedLoadingPerformSelector:@selector(goToMadeWords)];
}

-(void)goToMadeWords{
    WordsFromImport *wordsFromImport = [[WordsFromImport alloc] initWithNibName:@"WordsFromImport" bundle:nil];
    [self.navigationController pushViewController:wordsFromImport animated:YES]; 
}

-(void)didLogin{
    
}
-(void)loginDidReturnError{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [spreadsheets count];
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
    
    cell.imageView.image = SPREADSHEET_ASSET;
    
    GDataEntrySpreadsheet *spreadsheet = (GDataEntrySpreadsheet *)[spreadsheets objectAtIndex:row];
    [cell.textLabel setText:spreadsheet.title.stringValue];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self isLoading];
    int row = indexPath.row;
    GDataEntrySpreadsheet *spreadsheet = (GDataEntrySpreadsheet *)[spreadsheets objectAtIndex:row];
    [dao fetchSpreadsheet:spreadsheet];
}

-(void)isLoading{
    [UIView animateWithDuration:.5 animations:^{
        [self.activityIndicator setAlpha:1];
        [self.tableView setFrame:originalRect];
    }];
}
-(void)finishedLoadingPerformSelector:(SEL)selector{
    [UIView animateWithDuration:.5 animations:^{
        [self.activityIndicator setAlpha:0];
        [self.tableView setFrame:CGRectMake(tableView.frame.origin.x, 5, tableView.frame.size.width, tableView.frame.size.height)];
    } completion:^(BOOL finished) {
        if(selector != nil)[self performSelector:selector withObject:nil afterDelay:.5];
    }];
    
}

@end
