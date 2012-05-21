//
//  FlashCardDisplayPane.m
//  Language
//
//  Created by Eric Cancil on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlashCardDisplayPane.h"
#import "ActionSheetStringPicker.h"
#import "UserPreferenceConstants.h"
#import "FlashcardEnumerations.h"
#import "UserDefaultUtil.h"
#import "LocalizationStringConstants.h"
#import "StudyStyleModel.h"
@interface FlashCardDisplayPane ()
-(void)setupCardsBasedOnPrefs;
-(void)setCard:(CardBase *)theCard byEnum:(int)theEnum;
@property(nonatomic, retain) NSString *LANGUAGE_ONE_LABEL_S;
@property(nonatomic, retain) NSString *LANGUAGE_TWO_LABEL_S;
@property(nonatomic, retain) NSString *LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@property(nonatomic, retain) NSString *LANGUAGE_ONE_AND_LANGUAGE_TWO_LABEL_S;
@property(nonatomic, retain) NSString *LANGUAGE_ONE_AND_LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@property(nonatomic, retain) NSString *LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@property(nonatomic, retain) NSString *LANGUAGE_ONE_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@property(nonatomic, retain) NSString *IMAGE_ONLY_LABEL_S;
@property(nonatomic, retain) NSArray *flashcardDisplayArray;
@property(nonatomic, retain) NSArray *flashcardTypedAnswerDisplayArray;
@property(nonatomic, assign) BOOL isTypedAnswer;
@property(nonatomic, assign) BOOL shouldShowPickerOnViewLoad;

-(void)setupDisplayLabels;
@end
@implementation FlashCardDisplayPane
@synthesize instructionsLabel;
@synthesize front;
@synthesize back;
@synthesize currentlyEditingCard;
@synthesize currentlyEditingPreference;
@synthesize LANGUAGE_ONE_LABEL_S;
@synthesize LANGUAGE_TWO_LABEL_S;
@synthesize LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@synthesize LANGUAGE_ONE_AND_LANGUAGE_TWO_LABEL_S;
@synthesize LANGUAGE_ONE_AND_LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@synthesize LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@synthesize LANGUAGE_ONE_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S;
@synthesize IMAGE_ONLY_LABEL_S;
@synthesize flashcardDisplayArray;
@synthesize flashcardTypedAnswerDisplayArray;
@synthesize isTypedAnswer;
@synthesize shouldShowPickerOnViewLoad;


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
    
    self.title = NSLocalizedString(FLASHCARD_DISPLAY_PREFERENCE_PANE_TITLE, nil);
    
    self.instructionsLabel.text = NSLocalizedString(TAP_TO_LAYOUT_LABEL, nil);
    
    if([[StudyStyleModel getInstance] answerTypeTyped] == YES){
        isTypedAnswer = YES;
    }
        
    
    [self setupDisplayLabels];
    
    UITapGestureRecognizer *frontTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFrontTap:)];
    
    [self.front addGestureRecognizer:frontTap];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackTap:)];
    
    [self.back addGestureRecognizer:backTap];
    
    [self setupCardsBasedOnPrefs];
    
    if(shouldShowPickerOnViewLoad){
        [self performSelector:@selector(showPickerAfterWait) withObject:nil afterDelay:.5];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)showPickerAfterWait{
    self.currentlyEditingPreference = CARD_BACK_ENUMERATION;
    self.currentlyEditingCard = back;
    [self onDisplayChange:nil]; 
}

-(void)setupDisplayLabels{
    LANGUAGE_ONE_LABEL_S = NSLocalizedString(LANGUAGE_ONE_LABEL, nil);
    LANGUAGE_TWO_LABEL_S = NSLocalizedString(LANGUAGE_TWO_LABEL, nil);
    LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S = NSLocalizedString(LANGUAGE_TWO_SUPPLEMENTAL_LABEL, nil);
    LANGUAGE_ONE_AND_LANGUAGE_TWO_LABEL_S = NSLocalizedString(LANGUAGE_ONE_AND_LANGUAGE_TWO_LABEL, nil);
    LANGUAGE_ONE_AND_LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S = NSLocalizedString(LANGUAGE_ONE_AND_LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL, nil);
    LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S = NSLocalizedString(LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL, nil);
    LANGUAGE_ONE_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S = NSLocalizedString(LANGUAGE_ONE_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL, nil);
    IMAGE_ONLY_LABEL_S = NSLocalizedString(IMAGE_ONLY_LABEL, nil);
    flashcardDisplayArray = [NSArray arrayWithObjects:LANGUAGE_ONE_LABEL_S,LANGUAGE_TWO_LABEL_S,LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S,LANGUAGE_ONE_AND_LANGUAGE_TWO_LABEL_S,LANGUAGE_ONE_AND_LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S,LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S,LANGUAGE_ONE_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S,IMAGE_ONLY_LABEL_S, nil];
    
    flashcardTypedAnswerDisplayArray = [NSArray arrayWithObjects:LANGUAGE_ONE_LABEL_S,LANGUAGE_TWO_LABEL_S,LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S, nil];
}

-(void)setupCardsBasedOnPrefs{
    int frontEnum = [UserDefaultUtil getUserValueAsIntegerForKey:CARD_FRONT_ENUMERATION];
    int backEnum = [UserDefaultUtil getUserValueAsIntegerForKey:CARD_BACK_ENUMERATION];    
    if (frontEnum != 0) {
        [self setCard:front byEnum:frontEnum];
    }else{
        [self setCard:front byEnum:OnlyLanguageOne];
    }
    if (backEnum != 0) {
        [self setCard:back byEnum:backEnum];
    }else{
        [self setCard:back byEnum:OnlyLanguageTwo];
    }
}

-(void)setCard:(CardBase *)theCard byEnum:(int)theEnum{
    switch (theEnum) {
        case OnlyLanguageOne:
            [theCard setOnlyLanguageOne];
            break;
        case OnlyLanguageTwo:
            [theCard setOnlyLanguageTwo];
            break;
        case OnlyLanguageTwoSupplemental:
            [theCard setOnlyLanguageTwoSupplemental];
            break;
        case OnlyPhoto:
            [theCard setOnlyPhoto];
            break;
        case LanguageOneAndLanguageTwo:
            [theCard setLanguageOneAndLanguageTwo];
            break;
        case LanguageOneAndLanguageTwoSupplemental:
            [theCard setOnlyLanguageOne];
            break;
        case LanguageTwoAndLanguageTwoSupplemental:
            [theCard setLanguageTwoAndLanguageTwoSupplemental];
            break;
        case LanguageOneAndLanguageTwoAndLanguageTwoSupplemental:
            [theCard setLanguageOneAndLanguageTwoAndLanguageTwoSupplemental];
            break;
    }
}

- (void)viewDidUnload
{
    [self setFront:nil];
    [self setBack:nil];
    [self setInstructionsLabel:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)onFrontTap:(id)sender{
    self.currentlyEditingCard = front;
    self.currentlyEditingPreference = CARD_FRONT_ENUMERATION;
    [self onDisplayChange:sender];
}

-(void)onBackTap:(id)sender{
    self.currentlyEditingCard = back;
    self.currentlyEditingPreference = CARD_BACK_ENUMERATION;
    [self onDisplayChange:sender];
}

-(void)showBackPickerWithTruncatedList{
    shouldShowPickerOnViewLoad = YES;
}


- (IBAction)onDisplayChange:(id)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSString *value = selectedValue;
        if([value isEqualToString:LANGUAGE_ONE_LABEL_S]){
            [self.currentlyEditingCard setOnlyLanguageOne];
            [UserDefaultUtil setUserValueAsInteger:OnlyLanguageOne forKey:currentlyEditingPreference];
        }else if([value isEqualToString:LANGUAGE_TWO_LABEL_S]){
            [self.currentlyEditingCard setOnlyLanguageTwo];
            [UserDefaultUtil setUserValueAsInteger:OnlyLanguageTwo forKey:currentlyEditingPreference];
        }else if([value isEqualToString:LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S]){
            [self.currentlyEditingCard setOnlyLanguageTwoSupplemental];
            [UserDefaultUtil setUserValueAsInteger:OnlyLanguageTwoSupplemental forKey:currentlyEditingPreference];
        }else if([value isEqualToString:LANGUAGE_ONE_AND_LANGUAGE_TWO_LABEL_S]){
            [self.currentlyEditingCard setLanguageOneAndLanguageTwo];
            [UserDefaultUtil setUserValueAsInteger:LanguageOneAndLanguageTwo forKey:currentlyEditingPreference];
        }else if([value isEqualToString:LANGUAGE_ONE_AND_LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S]){
            [self.currentlyEditingCard setLanguageOneAndLanguageTwoAndLanguageTwoSupplemental];
            [UserDefaultUtil setUserValueAsInteger:LanguageOneAndLanguageTwoAndLanguageTwoSupplemental forKey:currentlyEditingPreference];
        }else if([value isEqualToString:LANGUAGE_TWO_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S]){
            [self.currentlyEditingCard setLanguageTwoAndLanguageTwoSupplemental];
            [UserDefaultUtil setUserValueAsInteger:LanguageTwoAndLanguageTwoSupplemental forKey:currentlyEditingPreference];
        }else if([value isEqualToString:LANGUAGE_ONE_AND_LANGUAGE_TWO_SUPPLEMENTAL_LABEL_S]){
            [self.currentlyEditingCard setLanguageOneAndLanguageTwoSupplemental];
            [UserDefaultUtil setUserValueAsInteger:LanguageOneAndLanguageTwoSupplemental forKey:currentlyEditingPreference];
        }else if([value isEqualToString:IMAGE_ONLY_LABEL_S]){
            [self.currentlyEditingCard setOnlyPhoto];
            [UserDefaultUtil setUserValueAsInteger:OnlyPhoto forKey:currentlyEditingPreference];
        }
 
};
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker){
        if(isTypedAnswer && currentlyEditingCard == back && shouldShowPickerOnViewLoad){
            [self performSelector:@selector(showAlertLater) withObject:nil afterDelay:.5];
            [self onDisplayChange:nil];
        }
        
    };
    
    //NSArray *rows = [NSArray arrayWithObjects:@"Only Romanji", @"Only Kanji", @"Only Kana", @"Romanji and Kanji", @"Romanji, Kanji and Kana", @"Kanji and Kana", @"Romanji and Kana", @"Only Image", nil];
    
    NSArray *rows;
    
    if(isTypedAnswer && currentlyEditingCard == back){
        rows = flashcardTypedAnswerDisplayArray;
    }else{
        rows = flashcardDisplayArray;
    }
    
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"Pick Layout" rows:rows initialSelection:0 doneBlock:done cancelBlock:cancel origin:self.currentlyEditingCard];
    
    [picker setOnActionSheetDone:done];
    [picker setOnActionSheetCancel:cancel];
    
    [picker showActionSheetPicker];
    
    // [ActionSheetStringPicker showPickerWithTitle:@"Add to Section" rows:rows initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
}

-(void)showAlertLater{
    return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Must choose one of these types" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
@end
