//
//  ChooseCreateScreen.m
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseCreateScreen.h"
#import "CreateGroup.h"
#import "AddWordsToGroup.h"
#import "CreateWord.h"
#import "CreateWordDataSource.h"
#import "AddWordModel.h"
#import "ImportFromGoogleDocs.h"
#import "StyledTableCell.h"
#import "KeychainUtil.h"
#import "GoogleDocsDisplayPane.h"
#import "GoogleLoginModel.h"
#import "GoogleDocsDisplayPaneDataSource.h"
#import "AssetConstants.h"
#import "CreateGroupDataSource.h"
#import "AddSectionModel.h"
@interface ChooseCreateScreen ()
@property (nonatomic, retain) NSArray *menuItems;
- (void)onCreateWord;
- (void)onCreateGroup;
- (void)onImportFromGoogle;
@end

@implementation ChooseCreateScreen
@synthesize tableView;
@synthesize menuItems;

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
    
    self.menuItems = [NSArray arrayWithObjects:NSLocalizedString(CHOOSE_CREATE_ADD_SECTION, nil) , NSLocalizedString(CHOOSE_CREATE_ADD_WORD, nil), NSLocalizedString(CHOOSE_CREATE_IMPORT_FROM_GOOGLE, nil), nil];
    [self.tableView reloadData];
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

- (void)onCreateWord {
    CreateWordDataSource *dataSource = [[CreateWordDataSource alloc] initWithModel:[[AddWordModel getInstance] clear]];
    CreateWord *createWord = [[CreateWord alloc] initWithNibName:@"CreateWord" bundle:nil formDataSource:dataSource];
    [self.navigationController pushViewController:createWord animated:YES];
}

- (void)onCreateGroup {
    CreateGroup *createGroup = [[CreateGroup alloc] initWithFormDataSource:[[CreateGroupDataSource alloc] initWithModel:[AddSectionModel getInstance]]];
    [self.navigationController pushViewController:createGroup animated:YES];
    
}

- (void)onImportFromGoogle {
    NSString *email = [KeychainUtil load:@"email"];
    NSString *password = [KeychainUtil load:@"password"];
    
    if(email && password){
        ImportFromGoogleDocs *import = [[ImportFromGoogleDocs alloc] initWithNibName:@"ImportFromGoogleDocs" bundle:nil];
        [self.navigationController pushViewController:import animated:YES];
    }else{
        GoogleDocsDisplayPane *googleDocsPane = [[GoogleDocsDisplayPane alloc] initWithFormDataSource:[[GoogleDocsDisplayPaneDataSource alloc] initWithModel:[GoogleLoginModel getInstance]]];
        [googleDocsPane setShouldGoToImport:YES];
        [self.navigationController pushViewController:googleDocsPane animated:YES];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
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
    
    NSString *item = [self.menuItems objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:item];
    
    if(indexPath.row == 0 || indexPath.row == 1)cell.imageView.image = USER_ADDED_ASSET;
    
        if(indexPath.row == 2)cell.imageView.image = GOOGLE_ASSET;
    
    return cell;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self onCreateGroup];
            break;
        case 1:
            [self onCreateWord];
            break;
        case 2:
            [self onImportFromGoogle];
            break;
            
        default:
            break;
    }
    
}

@end
