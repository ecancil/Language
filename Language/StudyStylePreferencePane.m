//
//  StudyStylePreferencePane.m
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudyStylePreferencePane.h"
#import "StudyStyleModel.h"
#import "FlashCardDisplayPane.h"
#import "UserPreferenceConstants.h"
#import "FlashcardEnumerations.h"
#import "UserDefaultUtil.h"
@interface StudyStylePreferencePane ()
@property(nonatomic, retain) StudyStyleModel *model;
@end
@implementation StudyStylePreferencePane
@synthesize tableView;
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
    
    self.model = [StudyStyleModel getInstance];
    
    [model addObserver:self forKeyPath:@"alphabetized" options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:@"randomized" options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:@"notSorted" options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:@"answerTypeTyped" options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:@"answerTypeNormal" options:NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self.tableView reloadData];
    if ([keyPath isEqualToString:@"answerTypeTyped"] && model.answerTypeTyped == YES) {
        int backEnumeration = [UserDefaultUtil getUserValueAsIntegerForKey:CARD_BACK_ENUMERATION];
        if(backEnumeration == OnlyLanguageOne || backEnumeration == OnlyLanguageTwo || backEnumeration == OnlyLanguageTwoSupplemental)return;
        UIAlertView *typeChangedAlert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You must change back view of your card to use this answer type" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK ->", nil];
        [typeChangedAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        model.answerTypeNormal = YES;
    }else{
        FlashCardDisplayPane *fcdp = [[FlashCardDisplayPane alloc] initWithNibName:@"FlashCardDisplayPane" bundle:nil];
        [fcdp showBackPickerWithTruncatedList];
        [self.navigationController pushViewController:fcdp animated:YES];
    }
}

-(void)dealloc{
    [model removeObserver:self forKeyPath:@"alphabetized"];
    [model removeObserver:self forKeyPath:@"randomized"];
    [model removeObserver:self forKeyPath:@"notSorted"];
    [model removeObserver:self forKeyPath:@"answerTypeTyped"];
    [model removeObserver:self forKeyPath:@"answerTypeNormal"];
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

@end
