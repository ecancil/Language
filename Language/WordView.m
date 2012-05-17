//
//  WordView.m
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WordView.h"
#import "SQLWord.h"
#import "ManagedObjectsDao.h"
#import "ActionSheetStringPicker.h"
#import "Word.h"
#import "SaveTypes.h"
#import "NotificationConstants.h"
#import "AddExamplesToWordPreviewController.h"
#import "AddWordModel.h"
#import "NSString+NSString_HTML_Utilities.h"
#import "AddWordModel.h"
#import "CreateWordDataSource.h"
#import "CreateWord.h"
#import "SpecialIdentifiers.h"
#import "SecondaryListModel.h"
#import "AppDelegate.h"
#import "ImagePreview.h"

@interface WordView () 
-(NSArray *)getActionSheetRows;
-(Section *)getSectionByTitle:(NSString *)title;
-(void)setDataToViews;
-(void)adjustAddToSectionVisibility;
-(void)adjustWordBankButton;
-(BOOL)isInWordbank;
-(void)adjustEditButton;
@end

@implementation WordView
@synthesize theImage;
@synthesize language1;
@synthesize language2;
@synthesize language2supplemental;
@synthesize addToSectionButton;
@synthesize wordBankButton;
@synthesize viewExamplesButton;
@synthesize previousButton;
@synthesize NextButton;
@synthesize imageButton;
@synthesize editButton;
@synthesize maDao;
@synthesize theWord;


-(void) setTheWord:(Word *)word{
    [self.navigationController popToRootViewControllerAnimated:YES];
    theWord = word;
    [self setDataToViews];
    [self adjustAddToSectionVisibility];
    [self adjustWordBankButton];
    [self adjustEditButton];
}

-(void)adjustEditButton{
    [editButton addTarget:self action:@selector(onEdit) forControlEvents:UIControlEventTouchUpInside];
}

-(void)adjustAddToSectionVisibility{
    if([self.getActionSheetRows count] == 0){
        [self.addToSectionButton setAlpha:0];
    }else{
        [self.addToSectionButton setAlpha:1];
    }
}

-(void)adjustWordBankButton{
    if([self isInWordbank]){
        [self.wordBankButton setTitle:@"Remove From Wordbank" forState:UIControlStateNormal];
    }else{
        [self.wordBankButton setTitle:@"Save To Wordbank" forState:UIControlStateNormal];
    }
}

-(BOOL)isInWordbank{
    return [self.daoInteractor wordExistsInWordBank:self.theWord];
}

-(void)setDataToViews{
    if(self.language1){
        [self.language1 setText:[theWord language1]];
    }
    if(self.language2){
        [self.language2 setText:[theWord language2]];
    }
    if(self.language1){
        [self.language2supplemental setText:[theWord language2supplemental]];
    }
    id img = theWord.image;
    if(self.theImage && theWord.image){
        [self.theImage setImage:(UIImage *)theWord.image];
    }
}

-(SQLWord *) getTheWord{
    return theWord;
}

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
    [self.navigationController setNavigationBarHidden:YES];
    [self.addToSectionButton setButtonColor:[UIColor blackColor]];
    [self.wordBankButton setButtonColor:[UIColor blackColor]];
    [self.viewExamplesButton setButtonColor:[UIColor blackColor]];
    [self.previousButton setButtonColor:[UIColor whiteColor]];
    [self.NextButton setButtonColor:[UIColor whiteColor]];    
    [self.addToSectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.wordBankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewExamplesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.NextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    [viewExamplesButton addTarget:self action:@selector(viewExamples) forControlEvents:UIControlEventTouchUpInside];
    
    [imageButton addTarget:self action:@selector(viewImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.NextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    [self.previousButton addTarget:self action:@selector(onPrevious) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    [self setDataToViews];
    maDao = [ManagedObjectsDao getInstance];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordBankUpdated:) name:WORDBANK_SAVED object:maDao];
}

-(void)onEdit{
    if([theWord.specialIdentifier isEqualToString:USER_CREATED] || [theWord.alternateSpecialIdentifier isEqualToString:USER_CREATED]){
        AddWordModel *wordModel = [AddWordModel getInstance];
        [wordModel updateValuesWithWord:theWord];
        CreateWord *createWord = [[CreateWord alloc] initEditorWithFormDataSource:[[CreateWordDataSource alloc] initWithModel:wordModel]];
        [self.navigationController pushViewController:createWord animated:YES];
        [createWord forceAddSaveButton];
    }else{
        UIAlertView *cloneAlert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Default words cannot be edited, instead you can clone them and they'll be added to user created words" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clone ->", nil];
        [cloneAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //[self.
}

-(void)viewExamples{
    [AddWordModel getInstance].examples = [theWord.examples markupFromHtml];
    AddExamplesToWordPreviewController *preview = [[AddExamplesToWordPreviewController alloc] initWithNibName:@"AddExamplesToWordPreviewController" bundle:nil];
    [self.navigationController pushViewController:preview animated:YES];
}

-(void)viewImage{
    ImagePreview *imagePreview = [[ImagePreview alloc] initWithImage:self.theWord.image];
    [self.navigationController pushViewController:imagePreview animated:YES];
}

-(void)onNext{
    [[NSNotificationCenter defaultCenter] postNotificationName:NEXT_PRESSED object:self];
}

-(void)onPrevious{
    [[NSNotificationCenter defaultCenter] postNotificationName:PREVIOUS_PRESSED object:self];    
}

- (void) wordBankUpdated:(NSNotification *) notification{
    [self adjustWordBankButton];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTheImage:nil];
    [self setLanguage1:nil];
    [self setLanguage2:nil];
    [self setLanguage2supplemental:nil];
    [self setWordBankButton:nil];
    [self setViewExamplesButton:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setImageButton:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onWordBankAdd:(id)sender {
    if([self isInWordbank]){
        [self.daoInteractor removeWordFromDefaultWordBank:self.theWord];
    }else{
        [self.daoInteractor addWordToDefaultWordBank:self.theWord];
    }
    [self adjustWordBankButton];
}

- (IBAction)onAddToSection:(id)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        Section *section = [self getSectionByTitle:selectedValue];
        if(section){
           [self.daoInteractor addWord:theWord ToSection:section];
        }
        [self adjustAddToSectionVisibility];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker){
        NSLog(@"Cancel");
    };
    
    NSArray *rows = [self getActionSheetRows];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"Add to Section" rows:rows initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
    [picker setOnActionSheetDone:done];
    [picker setOnActionSheetCancel:cancel];
    
    [picker showActionSheetPicker];
    
   // [ActionSheetStringPicker showPickerWithTitle:@"Add to Section" rows:rows initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setTheWord:theWord];
}

-(NSArray *)getActionSheetRows{
    NSArray *allUserSections = [self.daoInteractor getSanitizedUserCreatedSections];
    NSMutableArray *toReturn  = [[NSMutableArray alloc] init];
    int i;
    int j;
    for (i = 0; i < allUserSections.count; i ++) {
        Section *section = (Section *)[allUserSections objectAtIndex:i];
        BOOL existsInSection = NO;
        for (j = 0; j < section.wordIDs.count; j ++) {
            Word *word = [self getWordFromCollection:section.wordIDs ByRow:j];
            if ([theWord.language1 isEqualToString: word.language1]){
                existsInSection = YES;
            }
        }
        if(existsInSection == NO){
            [toReturn addObject:section.title];
        }
    }
    return toReturn.copy;
    return nil;
}

-(Section *)getSectionByTitle:(NSString *)title{
    NSArray *allUserSections = [self.daoInteractor getSanitizedUserCreatedSections];
    int i;
    for (i = 0; i < allUserSections.count; i ++) {
        Section *section = (Section *)[allUserSections objectAtIndex:i];
        if([section.title isEqualToString:title])
           return section;
    }
}

@end
