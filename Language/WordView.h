//
//  WordView.h
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLWord.h"
#import "ManagedObjectsDao.h"
#import "CoolButton.h"
#import "BaseViewController.h"
#import "Word.h"

@interface WordView : BaseViewController <UIAlertViewDelegate>{
    ManagedObjectsDao *maDao;
    Word *TheWord;
}
@property(nonatomic, retain) Word *theWord;

@property(nonatomic, retain) ManagedObjectsDao *maDao;
- (IBAction)onWordBankAdd:(id)sender;
- (IBAction)onAddToSection:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *theImage;
@property (strong, nonatomic) IBOutlet UILabel *language1;
@property (strong, nonatomic) IBOutlet UILabel *language2;
@property (strong, nonatomic) IBOutlet UILabel *language2supplemental;
@property (strong, nonatomic) IBOutlet CoolButton *addToSectionButton;
@property (strong, nonatomic) IBOutlet CoolButton *wordBankButton;
@property (strong, nonatomic) IBOutlet CoolButton *viewExamplesButton;
@property (strong, nonatomic) IBOutlet CoolButton *previousButton;
@property (strong, nonatomic) IBOutlet CoolButton *NextButton;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

@end
