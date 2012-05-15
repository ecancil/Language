//
//  CardBase.m
//  Language
//
//  Created by Eric Cancil on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardBase.h"
#import <QuartzCore/QuartzCore.h>

@interface CardBase ()
-(void)setupSubViews;
-(void)centerView:(UIView *)theView;
-(void)resetImage;
-(SQLWord *)getWord;
-(int)getFontSize;
-(void)layoutAndShowResultComponentsIncludeIncorrectButton:(BOOL)includeIncorrect;
-(void)hideResultComponents;

@end
@implementation CardBase
@synthesize language1;
@synthesize language2;
@synthesize language2supplemental;
@synthesize imageView;
@synthesize delegate;
@synthesize percentLabel;
@synthesize restartButton;
@synthesize studyIncorrectButton;
@synthesize doneButton;

static NSTimeInterval TIME_INTERVAL = .75;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubViews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupSubViews];
        self.layer.masksToBounds = NO;
        self.layer.shouldRasterize = YES;
        self.layer.cornerRadius = 8; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
       // self.layer.shadowColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

-(id)initWithDelegate:(id<CardDelegate>)theDelegate{
    if([super init]){
        self.delegate = theDelegate;
    }
    return self;
}

-(void)setupSubViews{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSString *language1Text = [[self getWord] language1];
    self.language1 = [[UILabel alloc] init];//initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.language1.font = [UIFont fontWithName:@"Arial" size:[self getFontSize]]; 
    self.language1.numberOfLines = 1;
    self.language1.textAlignment = UITextAlignmentCenter;
    [self.language1 setFrame:CGRectMake(0, 0, self.frame.size.width * .75, self.frame.size.height / 4)];
    self.language1.text = language1Text;
    self.language1.backgroundColor = [UIColor clearColor];
    self.language1.adjustsFontSizeToFitWidth = YES;

    [self.language1 setAlpha:0];
    [self addSubview:language1];
    [self centerView:self.language1];
    
    NSString *language2Text = [[self getWord] language2];
    self.language2 = [[UILabel alloc] init];//initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.language2.font = [UIFont fontWithName:@"Arial" size:[self getFontSize]]; 
    self.language2.numberOfLines = 1;
    self.language2.textAlignment = UITextAlignmentCenter;
    [self.language2 setFrame:CGRectMake(0, 0, self.frame.size.width * .75, self.frame.size.height / 4)];
    self.language2.text = language2Text;
    self.language2.backgroundColor = [UIColor clearColor];
    self.language2.adjustsFontSizeToFitWidth = YES;

    
    [self.language2 setAlpha:0];
    [self addSubview:self.language2];
    [self centerView:self.language2];
    
    NSString *language2supplementalText = [[self getWord] language2supplemental];
    self.language2supplemental = [[UILabel alloc] init];//initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.language2supplemental.font = [UIFont fontWithName:@"Arial" size:[self getFontSize]]; 
    self.language2supplemental.numberOfLines = 1;
    self.language2supplemental.textAlignment = UITextAlignmentCenter;
    [self.language2supplemental setFrame:CGRectMake(0, 0, self.frame.size.width * .75, self.frame.size.height / 4)];
    self.language2supplemental.text = language2supplementalText;
    self.language2supplemental.backgroundColor = [UIColor clearColor];
    self.language2supplemental.adjustsFontSizeToFitWidth = YES;
    
    [self.language2supplemental setAlpha:0];
    [self addSubview:self.language2supplemental];
    [self centerView:self.language2supplemental];
    
    self.imageView = [[UIImageView alloc] initWithImage:[[self getWord] image]];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView setAlpha:0];
    [self resetImage];
    [self addSubview:self.imageView];
    
    self.percentLabel = [[UILabel alloc] init];
    self.percentLabel.font = [UIFont fontWithName:@"Arial" size:[self getFontSize]]; 
    self.percentLabel.numberOfLines = 1;
    self.percentLabel.textAlignment = UITextAlignmentCenter;
    [self.percentLabel setFrame:CGRectMake(0, 0, self.frame.size.width * .75, self.frame.size.height / 4)];
    self.percentLabel.backgroundColor = [UIColor clearColor];
    self.percentLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.percentLabel setAlpha:0];
    [self addSubview:percentLabel];
    [self centerView:self.percentLabel];

    self.restartButton = [[CoolButton alloc] init];
    [self.restartButton addTarget:self action:@selector(onStudyAgainClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.restartButton setTitle:@"Restudy" forState:UIControlStateNormal];
    
    [self.restartButton setAlpha:0];
    [self addSubview:self.restartButton];
    [self centerView:self.restartButton];

    
    self.studyIncorrectButton = [[CoolButton alloc] init];
    [self.studyIncorrectButton addTarget:self action:@selector(onStudyIncorrectClicked:) forControlEvents:UIControlEventTouchUpInside];    
    [self.studyIncorrectButton setTitle:@"Study Incorrect" forState:UIControlStateNormal];
    
    [self.studyIncorrectButton setAlpha:0];
    [self addSubview:self.studyIncorrectButton];
    [self centerView:self.studyIncorrectButton];
    
    self.doneButton = [[CoolButton alloc] init];
    [self.doneButton addTarget:self action:@selector(onDoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [self.doneButton setAlpha:0];
    [self addSubview:self.doneButton];
    [self centerView:self.doneButton];
    [self.doneButton setButtonColor:[UIColor blackColor]];
    
}

-(void)onDoneButtonClicked:(id)sender{
    
    [self hideResultComponents];
    [self.delegate onDone];
}

-(void)onStudyIncorrectClicked:(id)sender{
    [self hideResultComponents];
    [self.delegate onStudyIncorrectItems];
}

-(void)onStudyAgainClicked:(id)sender{
    [self hideResultComponents];
    [self.delegate onRestudy];    
}

-(void)layoutAndShowResultComponentsIncludeIncorrectButton:(BOOL)includeIncorrect{
    int borderSize = 10;
    int buttonHeight = 40;
    
    CGRect doneFrame = CGRectMake(borderSize, self.bounds.size.height - borderSize - buttonHeight, self.bounds.size.width - (borderSize * 2), buttonHeight);
    [self.doneButton setAlpha:1];
    [self.doneButton setFrame:doneFrame];
    if (includeIncorrect) {
        CGRect studyIncorrectFrame = CGRectMake(borderSize, self.bounds.size.height - (borderSize * 2) - (buttonHeight * 2), self.bounds.size.width - (borderSize * 2), buttonHeight);
        [self.studyIncorrectButton setAlpha:1];
        [self.studyIncorrectButton setFrame:studyIncorrectFrame];
        
        CGRect restartFrame = CGRectMake(borderSize, self.bounds.size.height - (borderSize * 3) - (buttonHeight * 3), self.bounds.size.width - (borderSize * 2), buttonHeight);
        [self.restartButton setAlpha:1];
        [self.restartButton setFrame:restartFrame]; 
    }else{
        CGRect restartFrame = CGRectMake(borderSize, self.bounds.size.height - (borderSize * 2) - (buttonHeight * 2), self.bounds.size.width - (borderSize * 2), buttonHeight);
        [self.restartButton setAlpha:1];
        [self.restartButton setFrame:restartFrame]; 
    }
    
}

-(void)hideResultComponents{
    [UIView animateWithDuration:.5 animations:^{
        [self.doneButton setAlpha:0];
        [self.restartButton setAlpha:0];
        [self.studyIncorrectButton setAlpha:0];
        [self.percentLabel setAlpha:0];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(int)getFontSize{
    if(self.delegate && [self.delegate wordData]){
        return 50;
    }
    return 16;
}
-(void)centerView:(UIView *)theView{
    [theView setFrame:CGRectMake(self.bounds.size.width / 2 - theView.bounds.size.width / 2, 0, theView.bounds.size.width, theView.bounds.size.height)];
}

-(void)resetImage{
    CGFloat finalWidth = self.bounds.size.width * .1;
    CGFloat finalHeight = self.bounds.size.height * .1;
        [self.imageView setFrame:CGRectMake((self.bounds.size.width / 2 - finalWidth / 2), (self.bounds.size.height / 2 - finalHeight / 2), finalWidth, finalHeight)];
}

-(SQLWord *)getWord{
    SQLWord *theWord;
    if(self.delegate != nil){
        theWord = [delegate wordData];
    }
    if(theWord == nil){
        SQLWord *w = [[SQLWord alloc] init];
        w.language1 = @"Cat";
        w.language2 = @"猫";
        w.language2supplemental = @"ねこ";
        w.image = [UIImage imageNamed:@"cat.jpg"];
        theWord = w;
    }
    return theWord;
}

-(void)reloadData{
    [self setupSubViews];
}

-(void)resetViews{
    [UIView animateWithDuration:.3 animations:^{
        [self.language1 setAlpha:0];
        [self centerView:self.language1];
        [self.language2 setAlpha:0];
        [self centerView:self.language2];
        [self.language2supplemental setAlpha:0];
        [self centerView:self.language2supplemental];
        [self.imageView setAlpha:0];
        [self resetImage];
    } completion:^(BOOL finished) {
        //[self setupSubViews];
    }];
}

-(void)resetViewsWithoutAnimation{
        [self.language1 setAlpha:0];
        [self centerView:self.language1];
        [self.language2 setAlpha:0];
        [self centerView:self.language2];
        [self.language2supplemental setAlpha:0];
        [self centerView:self.language2supplemental];
        [self.imageView setAlpha:0];
        [self resetImage];
}

-(void)setOnlyLanguageOne{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language1 setAlpha:1];
        [self.language1 setFrame:CGRectMake(self.language1.frame.origin.x, self.bounds.size.height / 2 - self.language1.bounds.size.height / 2, self.language1.frame.size.width, self.language1.frame.size.height)];
        
        [self.language2 setAlpha:0];
        [self centerView:self.language2];
        [self.language2supplemental setAlpha:0];
        [self centerView:self.language2supplemental];
        [self.imageView setAlpha:0];
        [self resetImage];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setOnlyLanguageTwo{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language2 setAlpha:1];
        [self.language2 setFrame:CGRectMake(self.language2.frame.origin.x, self.bounds.size.height / 2 - self.language2.bounds.size.height / 2, self.language2.frame.size.width, self.language2.frame.size.height)];
        
        [self.language1 setAlpha:0];
        [self centerView:self.language1];
        [self.language2supplemental setAlpha:0];
        [self centerView:self.language2supplemental];
        [self.imageView setAlpha:0];
        [self resetImage];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setOnlyLanguageTwoSupplemental{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language2supplemental setAlpha:1];
        [self.language2supplemental setFrame:CGRectMake(self.language2supplemental.frame.origin.x, self.bounds.size.height / 2 - self.language2supplemental.bounds.size.height / 2, self.language2supplemental.frame.size.width, self.language2supplemental.frame.size.height)];
        
        [self.language1 setAlpha:0];
        [self centerView:self.language1];
        [self.language2 setAlpha:0];
        [self centerView:self.language2];
        [self.imageView setAlpha:0];
        [self resetImage];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }]; 
}

-(void)setOnlyPhoto{
    CGFloat finalWidth = self.bounds.size.width / 2;
    CGFloat finalHeight = self.bounds.size.height * .9;
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.imageView setAlpha:1];
        [self.imageView setFrame:CGRectMake((self.bounds.size.width / 2 - finalWidth / 2), (self.bounds.size.height / 2 - finalHeight / 2), finalWidth, finalHeight)];
        
        [self.language1 setAlpha:0];
        [self centerView:self.language1];
        [self.language2 setAlpha:0];
        [self centerView:self.language2];
        [self.language2supplemental setAlpha:0];
        [self centerView:self.language2supplemental];
    } completion:^(BOOL finished) {
        
    }]; 
    
}


-(void)setLanguageOneAndLanguageTwo{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language2 setAlpha:1];
        [self.language2 setFrame:CGRectMake(self.language2.frame.origin.x, self.bounds.size.height / 3 - self.language2.bounds.size.height / 2, self.language2.frame.size.width, self.language2.frame.size.height)];
        
        [self.language1 setAlpha:1];
         [self.language1 setFrame:CGRectMake(self.language1.frame.origin.x, ((self.bounds.size.height / 3)*2) - self.language1.bounds.size.height / 2, self.language1.frame.size.width, self.language1.frame.size.height)];
        
        [self.language2supplemental setAlpha:0];
        [self centerView:self.language2supplemental];
        [self.imageView setAlpha:0];
        [self resetImage];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setLanguageOneAndLanguageTwoAndLanguageTwoSupplemental{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language2 setAlpha:1];
        [self.language2 setFrame:CGRectMake(self.language2.frame.origin.x, self.bounds.size.height / 4 - self.language2.bounds.size.height / 2, self.language2.frame.size.width, self.language2.frame.size.height)];
        
        [self.language1 setAlpha:1];
        [self.language1 setFrame:CGRectMake(self.language1.frame.origin.x, ((self.bounds.size.height / 4)*2) - self.language1.bounds.size.height / 2, self.language1.frame.size.width, self.language1.frame.size.height)];
        
        [self.language2supplemental setAlpha:1];
        [self.language2supplemental setFrame:CGRectMake(self.language2supplemental.frame.origin.x, ((self.bounds.size.height / 4)*3 ) - self.language2supplemental.bounds.size.height / 2, self.language2supplemental.frame.size.width, self.language2supplemental.frame.size.height)];
        
        [self resetImage];
        [self.imageView setAlpha:0];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setLanguageOneAndLanguageTwoSupplemental{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language1 setAlpha:1];
        [self.language1 setFrame:CGRectMake(self.language1.frame.origin.x, self.bounds.size.height / 3 - self.language1.bounds.size.height / 2, self.language1.frame.size.width, self.language1.frame.size.height)];
        
        [self.language2supplemental setAlpha:1];
        [self.language2supplemental setFrame:CGRectMake(self.language2supplemental.frame.origin.x, ((self.bounds.size.height / 3)*2) - self.language2supplemental.bounds.size.height / 2, self.language1.frame.size.width, self.language2supplemental.frame.size.height)];
        
        [self.language2 setAlpha:0];
        [self centerView:self.language2];
        [self.imageView setAlpha:0];
        [self resetImage];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }];

}
-(void)setLanguageTwoAndLanguageTwoSupplemental{
    [UIView animateWithDuration:TIME_INTERVAL animations:^{
        [self.language2 setAlpha:1];
        [self.language2 setFrame:CGRectMake(self.language2.frame.origin.x, self.bounds.size.height / 3 - self.language2.bounds.size.height / 2, self.language2.frame.size.width, self.language2.frame.size.height)];
        
        [self.language2supplemental setAlpha:1];
        [self.language2supplemental setFrame:CGRectMake(self.language2supplemental.frame.origin.x, ((self.bounds.size.height / 3)*2) - self.language2supplemental.bounds.size.height / 2, self.language1.frame.size.width, self.language2supplemental.frame.size.height)];
        
        [self.language1 setAlpha:0];
        [self centerView:self.language1];
        [self.imageView setAlpha:0];
        [self resetImage];
        //[self centerView:self.imageView];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showResultsWithAmountCorrect:(unsigned int)amountCorrect andAmountIncorrect:(unsigned int)amountIncorrect andTotalItems:(unsigned int)totalItems andIncorrectItems:(NSArray *)incorrectItems{
    double percent = (double)amountCorrect / (double)totalItems * 100;
    [self.percentLabel setText:[NSString stringWithFormat:@"%d / %d correct - %d%%", amountCorrect, totalItems, (int)ceil(percent-0.5) == 1 || totalItems == 0 ? 0 : (int)ceil(percent-0.5)]];
    [self.percentLabel setAlpha:1];

    [self layoutAndShowResultComponentsIncludeIncorrectButton:incorrectItems && incorrectItems.count > 0];

    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
    } completion:^(BOOL finished) {
        
    }];
}

-(void)studyAgain{
    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:^(BOOL finished) {
        
    }]; 
}

@end
