//
//  CreateGroup.m
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateGroup.h"
#import "AddWordsToGroup.h"
#import "SaveTypes.h"
#import "AddSectionModel.h"
#import "IBAInputManager.h"
#import "CreateGroupDataSource.h"
#import "LocalizationStringConstants.h"
@interface CreateGroup ()
@property (nonatomic, retain) AddSectionModel *model;
@property (nonatomic, assign) BOOL isShowingButtons;
@end
@implementation CreateGroup
@synthesize tableView;
@synthesize maDao;
@synthesize model;
@synthesize isShowingButtons;


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
    
    self.title = NSLocalizedString(ADD_SECTION_TITLE, nil);
    
    model = [AddSectionModel getInstance];
    
    [model clear];
    
    maDao = [ManagedObjectsDao getInstance];
    
    // Do any additional setup after loading the view from its nib.
   
    
    [self.formDataSource addObserver:self forKeyPath:@"shouldShowSaveButton" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)dealloc{
    [self.formDataSource removeObserver:self forKeyPath:@"shouldShowSaveButton"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CreateGroupDataSource *typedDataSource = (CreateGroupDataSource *) self.formDataSource;
    if(typedDataSource.shouldShowSaveButton){
        self.title = @"";
        UIBarButtonItem *addWordsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(ADD_WORDS_TO_SECTION_BUTTON_LABEL, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(addWords:)];
        UIBarButtonItem *createGroupButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(ADD_SECTION_BUTTON_LABEL, nil) style:UIBarButtonItemStyleDone target:self action:@selector(create:)];
        
        if(!self.isShowingButtons)[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addWordsButton, createGroupButton, nil] animated:YES];
        self.isShowingButtons = YES;
    }else{
      [self.navigationItem setRightBarButtonItems:[[NSArray alloc] init] animated:YES];
        self.title = NSLocalizedString(ADD_SECTION_TITLE, nil);
        self.isShowingButtons = NO;
    }
}

-(void)addWords:(id)sender{
    AddWordsToGroup *add = [[AddWordsToGroup alloc] initWithNibName:@"AddWordsToGroup" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}

-(void)create:(id)sender{
    [[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil];
    [self.daoInteractor addNewSectionByTitle:model.sectionName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wasSaved:) name:USER_SECTION_SAVED object:nil];
}

- (void) wasSaved:(NSNotification *) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
