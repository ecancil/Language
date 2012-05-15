//
//  GoogleDocsDisplayPane.m
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleDocsDisplayPane.h"
//#import "GoogleDocsDao.h"
#import "GDataEntrySpreadsheetList.h"
#import "NotificationConstants.h"
#import "KeychainUtil.h"
#import "GoogleLoginModel.h"
#import "ImportFromGoogleDocs.h"
@interface GoogleDocsDisplayPane ()
-(void)addClearButton;
//@property(nonatomic, retain) GoogleDocsDao *dao;
@end
@implementation GoogleDocsDisplayPane
@synthesize tableView;
@synthesize activityIndicator;
@synthesize shouldGoToImport;
//@synthesize dao;

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
    [self addClearButton];
    [activityIndicator setAlpha:0];
    [activityIndicator startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onError:) name:GMAIL_LOGIN_ERROR object:self.formDataSource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccess:) name:GMAIL_LOGIN_SUCCESS object:self.formDataSource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStartedVerify:) name:STARTED_VERIFYING_GMAIL object:self.formDataSource];
    //dao = [[GoogleDocsDao alloc] initWithResponder:self];
    //[dao  fetchFeedOfSpreadsheets];
   // [dao loginWithName:@"eric@appdivision.com" password:@"Ec@ncil111"];

    // Do any additional setup after loading the view from its nib.
}

-(void)addClearButton{
    NSString *email = [KeychainUtil load:@"email"];
    NSString *password = [KeychainUtil load:@"password"];
    if(!email && !password){
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }else{
        UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove login" style:UIBarButtonItemStyleDone target:self action:@selector(onClear)];
    
        [self.navigationItem setRightBarButtonItem:clearItem animated:YES];
    }
    
}

-(void)onClear{
    GoogleLoginModel *model = [GoogleLoginModel getInstance];
    model.email = model.password = nil;
    [KeychainUtil save:@"email" data:nil];
    [KeychainUtil save:@"password" data:nil];
    [self.formDataSource performSelector:@selector(clearFields)];
    [self addClearButton];
}

- (void) onError:(NSNotification *)notification{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"There was an error logging in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [activityIndicator setAlpha:0];
}

- (void) onSuccess:(NSNotification *)notification{
    [activityIndicator setAlpha:0];
    [self addClearButton];
    if(self.shouldGoToImport){
        ImportFromGoogleDocs *import = [[ImportFromGoogleDocs alloc] initWithNibName:@"ImportFromGoogleDocs" bundle:nil];
        [self.navigationController pushViewController:import animated:YES];
    }
}

- (void) onStartedVerify:(NSNotification *)notification{
    [activityIndicator setAlpha:1];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
