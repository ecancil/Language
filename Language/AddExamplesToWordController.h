//
//  AddExamplesToWordController.h
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddWordModel.h"

@interface AddExamplesToWordController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *addExamplesInstructionsLabel;
@property (strong, nonatomic) IBOutlet UITextView *examplesInput;
@property (strong, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, assign) BOOL keyboardVisible;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, strong) AddWordModel *addWordModel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *lineBreakButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *boldButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *colorButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *hruleButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *underlineButton;
@end
