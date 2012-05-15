//
//  PreferencesPane.m
//  Language
//
//  Created by Eric Cancil on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreferencesPane.h"
#import "FlashCardDisplayPane.h"
#import "StyledTableCell.h"
#import "GoogleDocsDisplayPane.h"
#import "GoogleDocsDisplayPaneDataSource.h"
#import "GoogleLoginModel.h"
#import "StudyRemindersPreferencePane.h"
#import "AssetConstants.h"
#import "StudyStyleModel.h"
#import "StudyStyleDataSource.h"
#import "StudyStylePreferencePane.h"
#import "ManagedObjectsDao.h"
@implementation PreferencesPane
@synthesize tableView;

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
    
    [self.navigationController.navigationBar setBarStyle: UIStatusBarStyleBlackTranslucent];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneClick:)];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObject:doneButton]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onDoneClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    int row = indexPath.row;
    if(row == 0){
       cell.textLabel.text = @"Flashcard Display"; 
        cell.imageView.image = EDIT_CARD_ASSET;
    }else
        if(row == 1){
            cell.textLabel.text = @"Study Style";
            cell.imageView.image = EDIT_CARD_ASSET;
        }else 
            if(row == 2){
                cell.textLabel.text = @"Google Docs Login Info";
                cell.imageView.image = GOOGLE_ASSET;
            }else
                if(row == 3){
                    cell.textLabel.text = @"Study Reminders";
                    cell.imageView.image = NOTIFICATION_ASSET;
                }else
                    if (row == 4) {
                        cell.textLabel.text = @"Reset Answer Statistics";
                        cell.imageView.image = RESET_STATISTICS;
                    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Flashcards";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    if(row == 0){
        FlashCardDisplayPane *flashCardPane = [[FlashCardDisplayPane alloc] initWithNibName:@"FlashCardDisplayPane" bundle:nil];
        [self.navigationController pushViewController:flashCardPane animated:YES];
    }else
        if(row == 1){
            StudyStylePreferencePane *studyStyle = [[StudyStylePreferencePane alloc] initWithFormDataSource:[[StudyStyleDataSource alloc] initWithModel:[StudyStyleModel getInstance]]];
            [self.navigationController pushViewController:studyStyle animated:YES];
        }else
            if(row == 2){
                GoogleDocsDisplayPane *googleDocsPane = [[GoogleDocsDisplayPane alloc] initWithFormDataSource:[[GoogleDocsDisplayPaneDataSource alloc] initWithModel:[GoogleLoginModel getInstance]]];
                [self.navigationController pushViewController:googleDocsPane animated:YES];
            }else
                if(row == 3){
                    StudyRemindersPreferencePane *reminders = [[StudyRemindersPreferencePane alloc] initWithNibName:@"StudyRemindersPreferencePane" bundle:nil];
                    [self.navigationController pushViewController:reminders animated:YES];
                }else
                    if(row == 4){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Hitting OK will destroy all progress up to date" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                        [alert show];
                    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self viewDidDisappear:YES];  
            break;
        case 1:
            [[ManagedObjectsDao getInstance] deleteAllTallies];
            [self viewDidDisappear:YES];
            break;
        default:
            break;
    }
}
@end
