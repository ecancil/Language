//
//  FlashCard.h
//  Language
//
//  Created by Eric Cancil on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDelegate.h"
#import "SecondaryListModel.h"
#import "CardBase.h"
#import "ManagedObjectsDao.h"
#import "SingleFlashcardSession.h"
#import "BaseViewController.h"
#import "AddedFlashcardDelegate.h"

@interface FlashCard : BaseViewController <CardDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, retain) SecondaryListModel *model;
@property(nonatomic, retain) SingleFlashcardSession *singleFlashcardSessionModel;
@property (strong, nonatomic) IBOutlet CardBase *theCard;
@property (strong, nonatomic) IBOutlet CoolButton *rightButton;
- (IBAction)rightButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet CoolButton *wrongButton;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) ManagedObjectsDao *maDao;
@property (nonatomic, retain) NSString *currentState;
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
- (IBAction)wrongButtonClicked:(id)sender;
-(void)showNextFlashcard;
-(void)showAnswer;
- (IBAction)onClose:(id)sender;
-(id)initWithFlashcardWords:(NSArray *)words;
@property (strong, nonatomic) IBOutlet UITextField *typedAnswerField;
@property (strong, nonatomic) IBOutlet CoolButton *submitButton;
@property (strong, nonatomic) IBOutlet UIToolbar *hideKeyboardBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *hideKeyboardButton;
- (IBAction)onHideKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property(nonatomic, retain) <AddedFlashcardDelegate>id flashcardDelegate;
@end
