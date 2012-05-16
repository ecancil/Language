//
//  FlashCard.m
//  Language
//
//  Created by Eric Cancil on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"
#import "SQLWord.h"
#import "AnswerTally.h"
#import "UserPreferenceConstants.h"
#import "FlashcardEnumerations.h"
#import "UserDefaultUtil.h"
#import "UserDefaultUtil.h"
#import "UserPreferenceConstants.h"
@interface FlashCard ()
-(void)expandAndHideWithAnimation:(BOOL)animate withSelector:(SEL)selector;
-(void)shrinkAndShowWithAnimation:(BOOL)animate withSelector:(SEL)selector;
-(void)revealInputWithAnimation;
-(void)hideInputWithAnimationAndSelector:(SEL)selector;
-(void)addTapRecognizer;
-(void)removeTapRecognizer;
-(void)setupCardsBasedOnPrefs;
-(void)setCardByEnum:(int)theEnum;
-(NSArray *)fillCollectionWithObjects:(NSArray *)collection;
@property(nonatomic, assign) BOOL isTypedResponseStyle;
@end
@implementation FlashCard
@synthesize resultLabel;
@synthesize typedAnswerField;
@synthesize submitButton;
@synthesize hideKeyboardBar;
@synthesize hideKeyboardButton;
@synthesize wrongButton;
@synthesize model;
@synthesize theCard;
@synthesize rightButton;
@synthesize index;
@synthesize  originalFrame;
@synthesize maDao;
@synthesize currentState;
@synthesize singleFlashcardSessionModel;
@synthesize tapRecognizer;
@synthesize isTypedResponseStyle;

static NSString *FRONT_STATE = @"front";
static NSString *BACK_STATE = @"back";

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

-(id)initWithFlashcardWords:(NSArray *)words{
    
    isTypedResponseStyle = [[UserDefaultUtil getUserValueAsStringForKey:CARD_ANSWER_TYPE_KEY] isEqualToString:CARD_ANSWER_TYPE_TYPED];
    
    words = [self fillCollectionWithObjects:words];
    
    if([[UserDefaultUtil getUserValueAsStringForKey:CARD_ORDER_KEY] isEqualToString:CARD_ORDER_VALUE_ALPHABETIZED] || [UserDefaultUtil getUserValueAsStringForKey:CARD_ORDER_KEY] == nil){
        
        NSSortDescriptor *language1Descriptor = [[NSSortDescriptor alloc] initWithKey:@"language1" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        
        words = [words sortedArrayUsingDescriptors:[NSArray arrayWithObject:language1Descriptor]];
        
    }else if([[UserDefaultUtil getUserValueAsStringForKey:CARD_ORDER_KEY] isEqualToString:CARD_ORDER_VALUE_RANDOMIZED]){
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[words count]];
        
        for (id anObject in words)
        {
            NSUInteger randomPos = arc4random()%([tmpArray count]+1);
            [tmpArray insertObject:anObject atIndex:randomPos];
        }
        
        words = [NSArray arrayWithArray:tmpArray]; 
    }else if([[UserDefaultUtil getUserValueAsStringForKey:CARD_ORDER_KEY] isEqualToString:CARD_ORDER_VALUE_NOT_SORTED]){
      //do nothing here   
    }
    
    if([self initWithNibName:@"FlashCard" bundle:nil]){
        self.singleFlashcardSessionModel = [[SingleFlashcardSession alloc] init];
        self.singleFlashcardSessionModel.sessionWords = words;
    }
    
    return self;
}

-(NSArray *)fillCollectionWithObjects:(NSArray *)collection{
    int i = 0;
    NSArray *copy = collection.copy;
    NSMutableArray *holder = [[NSMutableArray alloc] initWithCapacity:copy.count];
    int count = copy.count;
    for (i; i < count; i ++) {
        Word *word = [self getWordFromCollection:copy ByRow:i];
        [holder addObject:word];
    }
    return holder;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.submitButton.buttonColor = self.rightButton.buttonColor = self.wrongButton.buttonColor = [UIColor blackColor];
    
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.wrongButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    
    maDao = [ManagedObjectsDao getInstance];
    
    [self addTapRecognizer];
    
    
    self.originalFrame = theCard.frame;
    
    model = [SecondaryListModel getInstance];
    
    self.theCard.delegate = self;
    
    [self.wrongButton setAlpha:0];
    [self.rightButton setAlpha:0];
    [self.typedAnswerField setAlpha:0];
    [self.submitButton setAlpha:0];
    [self.resultLabel setAlpha:0];
    
    if(isTypedResponseStyle){
        self.currentState = FRONT_STATE;
        [self showNextFlashcard];
    }else{
        [self expandAndHideWithAnimation:NO withSelector:@selector(showNextFlashcard)];
    }
    
    [self.submitButton addTarget:self action:@selector(onSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    hideKeyboardBar.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)keyboardDidShow:(NSNotification *)notification{
    self.hideKeyboardBar.alpha = 1;    
    NSDictionary *info = notification.userInfo;
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect newFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - keyboardSize.height - self.hideKeyboardBar.frame.size.height - 15, self.hideKeyboardBar.frame.size.width, self.hideKeyboardBar.frame.size.height);
    [self.hideKeyboardBar setFrame:newFrame];
    
}

-(void)keyboardDidHide:(NSNotification *)notification{
    self.hideKeyboardBar.alpha = 0;   
}

-(void)onSubmit{
  
    int backEnum = [UserDefaultUtil getUserValueAsIntegerForKey:CARD_BACK_ENUMERATION];    
    NSString *correctAnswer;
    
    switch (backEnum) {
        case OnlyLanguageOne:
            correctAnswer = self.wordData.language1;
            break;
        case OnlyLanguageTwo:
            correctAnswer = self.wordData.language2;
            break;
        case OnlyLanguageTwoSupplemental:
            correctAnswer = self.wordData.language2supplemental;
            break;
    }

    if ([correctAnswer isEqualToString:self.typedAnswerField.text]) {
        self.resultLabel.textColor = [UIColor greenColor];
        self.resultLabel.text = @"CORRECT";
        [self hideInputWithAnimationAndSelector:@selector(showNextFlashcard)];
    }else{
        self.resultLabel.textColor = [UIColor redColor];
        self.resultLabel.text = @"INCORRECT";
        [self.singleFlashcardSessionModel.wrongItems addObject:self.wordData];
        [self hideInputWithAnimationAndSelector:@selector(showNextFlashcard)];
    }
    [self.hideKeyboardBar setAlpha:0];
    [self.typedAnswerField resignFirstResponder];
   /* - (IBAction)rightButtonClicked:(id)sender {
        [self expandAndHideWithAnimation:YES withSelector:@selector(showNextFlashcard)];
        AnswerTally * tally = [maDao updateOrCreateAnswerTallyByWord:self.wordData wasCorrect:YES];
    }
    - (IBAction)wrongButtonClicked:(id)sender {
        [self.singleFlashcardSessionModel.wrongItems addObject:self.wordData];
        [self expandAndHideWithAnimation:YES withSelector:@selector(showNextFlashcard)];
        AnswerTally * tally = [maDao updateOrCreateAnswerTallyByWord:self.wordData wasCorrect:NO];
    }*/
}

-(void)onTap:(id)sender{
    if (self.currentState == BACK_STATE)return;
    if(isTypedResponseStyle){
        [self revealInputWithAnimation];
    }else{
        [self shrinkAndShowWithAnimation:YES withSelector:@selector(showAnswer)];
    }
}

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *theView = gestureRecognizer.view;
    CGPoint location = [gestureRecognizer locationInView:theCard];
    UIView *hitView = [theCard hitTest:location withEvent:nil];
    
    if ([hitView isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}*/

-(void)addTapRecognizer{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    
    tapRecognizer.delegate = self;
    
    [self.theCard addGestureRecognizer:tapRecognizer]; 
}
-(void)removeTapRecognizer{
    [self.theCard removeGestureRecognizer:self.tapRecognizer];
    tapRecognizer = nil;
}

-(void)setupCardsBasedOnPrefs{
    int frontEnum = [UserDefaultUtil getUserValueAsIntegerForKey:CARD_FRONT_ENUMERATION];
    int backEnum = [UserDefaultUtil getUserValueAsIntegerForKey:CARD_BACK_ENUMERATION];    

    if (currentState == FRONT_STATE) {
        if (frontEnum != 0) {
            [self setCardByEnum:frontEnum];
        }else{
            [self setCardByEnum:OnlyLanguageOne];
        }
    }else if (currentState == BACK_STATE){
        if (backEnum != 0) {
            [self setCardByEnum:backEnum];
        }else{
            [self setCardByEnum:OnlyLanguageTwo];
        }
    }
}

-(void)setCardByEnum:(int)theEnum{
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

-(void)showNextFlashcard{
    if (self.singleFlashcardSessionModel.isSupplementaryStudy) {
        if(self.singleFlashcardSessionModel.cardIndex + 1 == self.singleFlashcardSessionModel.supplementarySessionWords.count){
            [self removeTapRecognizer];
            [self.theCard resetViewsWithoutAnimation];
            [theCard showResultsWithAmountCorrect:self.singleFlashcardSessionModel.supplementarySessionWords.count - self.singleFlashcardSessionModel.wrongItems.count andAmountIncorrect:self.singleFlashcardSessionModel.wrongItems.count andTotalItems:self.singleFlashcardSessionModel.supplementarySessionWords.count andIncorrectItems:self.singleFlashcardSessionModel.wrongItems];
        }else{
            self.singleFlashcardSessionModel.cardIndex ++;
            [theCard reloadData];
            
            //[theCard setLanguageTwoAndLanguageTwoSupplemental];
            [self setupCardsBasedOnPrefs];
        }
    }else{
        if(self.singleFlashcardSessionModel.cardIndex + 1 == self.singleFlashcardSessionModel.sessionWords.count){
            [self removeTapRecognizer];
            [self.theCard resetViewsWithoutAnimation];            
            [theCard showResultsWithAmountCorrect:self.singleFlashcardSessionModel.sessionWords.count - self.singleFlashcardSessionModel.wrongItems.count andAmountIncorrect:self.singleFlashcardSessionModel.wrongItems.count andTotalItems:self.singleFlashcardSessionModel.sessionWords.count andIncorrectItems:self.singleFlashcardSessionModel.wrongItems];
        }else{
            self.singleFlashcardSessionModel.cardIndex ++;
            [theCard reloadData];
            
            //[theCard setLanguageTwoAndLanguageTwoSupplemental];
            [self setupCardsBasedOnPrefs];
        } 
    }
    
}

-(void)showAnswer{
    //[theCard reloadData];
    //[theCard setOnlyLanguageOne];
    [self setupCardsBasedOnPrefs];
}

- (IBAction)onClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [self setTheCard:nil];
    [self setRightButton:nil];
    [self setWrongButton:nil];
    [self setTypedAnswerField:nil];
    [self setSubmitButton:nil];
    [self setHideKeyboardBar:nil];
    [self setHideKeyboardButton:nil];
    [self setResultLabel:nil];
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

-(SQLWord *)wordData{
    Word *word;
    if(self.singleFlashcardSessionModel.isSupplementaryStudy){
       // word = (Word *)[self.singleFlashcardSessionModel.supplementarySessionWords objectAtIndex:self.singleFlashcardSessionModel.cardIndex];
        word = [self getWordFromCollection:self.singleFlashcardSessionModel.supplementarySessionWords ByRow:self.singleFlashcardSessionModel.cardIndex];
    }else{
        //word = (Word *)[self.singleFlashcardSessionModel.sessionWords objectAtIndex:self.singleFlashcardSessionModel.cardIndex];
        word = [self getWordFromCollection:self.singleFlashcardSessionModel.sessionWords ByRow:self.singleFlashcardSessionModel.cardIndex];
    }
    return word;
}

- (IBAction)rightButtonClicked:(id)sender {
    [self expandAndHideWithAnimation:YES withSelector:@selector(showNextFlashcard)];
    AnswerTally * tally = [self.daoInteractor updateOrCreateAnswerTallyByWord:self.wordData wasCorrect:YES];
}
- (IBAction)wrongButtonClicked:(id)sender {
    [self.singleFlashcardSessionModel.wrongItems addObject:self.wordData];
    [self expandAndHideWithAnimation:YES withSelector:@selector(showNextFlashcard)];
    AnswerTally * tally = [self.daoInteractor updateOrCreateAnswerTallyByWord:self.wordData wasCorrect:NO];
}

-(void)expandAndHideWithAnimation:(BOOL)animate withSelector:(SEL)selector{
    [theCard resetViews];
    NSTimeInterval duration = animate ? .3 : 0;
    [UIView animateWithDuration:duration animations:^{
        [rightButton setAlpha:0];
        [wrongButton setAlpha:0];
        [self.theCard setFrame:CGRectMake(self.theCard.frame.origin.x, self.theCard.frame.origin.y, self.theCard.bounds.size.width, self.wrongButton.frame.origin.y + self.wrongButton.frame.size.height - self.theCard.frame.origin.y)];
    } completion:^(BOOL finished) {
        if(selector){
            self.currentState = FRONT_STATE;
            [self performSelector:selector];
        }
    }];
}


-(void)revealInputWithAnimation{
    self.typedAnswerField.text = @"";
    [UIView animateWithDuration:.3 animations:^{
        self.currentState = FRONT_STATE;
        [self.typedAnswerField setAlpha:1];
        [self.submitButton setAlpha:1];
        [self.theCard setFrame:CGRectMake(self.theCard.frame.origin.x, submitButton.frame.origin.y + submitButton.frame.size.height + 10, self.theCard.frame.size.width, self.theCard.frame.size.height)];
    }completion:^(BOOL finished) {
        [self.typedAnswerField becomeFirstResponder];
    }];
}

-(void)hideInputWithAnimationAndSelector:(SEL)selector{
    [UIView animateWithDuration:.3 animations:^{
        self.currentState = BACK_STATE;
        [self setupCardsBasedOnPrefs];
        [self.resultLabel setAlpha:1];
        [self.theCard setFrame:CGRectMake(self.theCard.frame.origin.x, resultLabel.frame.origin.y + resultLabel.frame.size.height + 10, self.theCard.frame.size.width, self.theCard.frame.size.height)];
    }completion:^(BOOL finished) {
        [self performSelector:@selector(resetLater) withObject:nil afterDelay:1];
        [UIView animateWithDuration:.3 delay:1 options:nil animations:^{
            [self.typedAnswerField setAlpha:0];
            [self.submitButton setAlpha:0];
            [self.resultLabel setAlpha:0];
            [self.theCard setFrame:originalFrame];
        } completion:^(BOOL finished) {
            self.currentState = FRONT_STATE;
            if(selector)[self performSelector:selector];
        }];
    }];
}

-(void)resetLater{
    [theCard resetViews];
}

-(void)shrinkAndShowWithAnimation:(BOOL)animate withSelector:(SEL)selector{
    [theCard resetViews];
    NSTimeInterval duration = animate ? .3 : 0;
    [UIView animateWithDuration:duration animations:^{
        [rightButton setAlpha:1];
        [wrongButton setAlpha:1];
        [self.theCard setFrame:originalFrame];
    } completion:^(BOOL finished) {
        if(selector){
            self.currentState = BACK_STATE;
            [self performSelector:selector];
        }
    }]; 
}

-(void)onStudyIncorrectItems{
    [self addTapRecognizer];
    [self.singleFlashcardSessionModel studyIncorrect];
    [self.theCard studyAgain];
    [self expandAndHideWithAnimation:NO withSelector:@selector(showNextFlashcard)];
}
-(void)onRestudy{
    [self addTapRecognizer];
    [self.singleFlashcardSessionModel restudy];
    [self.theCard studyAgain];
    [self expandAndHideWithAnimation:NO withSelector:@selector(showNextFlashcard)];
}
-(void)onDone{
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)onHideKeyboard:(id)sender {
    [self.typedAnswerField resignFirstResponder];
    [UIView animateWithDuration:.2 animations:^{
         self.hideKeyboardBar.alpha = 0;        
    }];
}
@end
