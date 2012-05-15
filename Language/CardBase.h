//
//  CardBase.h
//  Language
//
//  Created by Eric Cancil on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CoolButton.h"

@interface CardBase : UIView{
    id<CardDelegate> delegate;
}

@property(nonatomic, retain) id<CardDelegate> delegate;
@property(nonatomic, retain) UILabel *language1;
@property(nonatomic, retain) UILabel *language2;
@property(nonatomic, retain) UILabel *language2supplemental;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) CoolButton *restartButton;
@property(nonatomic, retain) CoolButton *studyIncorrectButton;
@property(nonatomic, retain) CoolButton *doneButton;

@property(nonatomic, retain) UILabel *percentLabel;

-(void)resetViews;
-(void)setOnlyLanguageOne;
-(void)setOnlyLanguageTwo;
-(void)setOnlyLanguageTwoSupplemental;
-(void)setOnlyPhoto;
-(void)setLanguageOneAndLanguageTwo;
-(void)setLanguageOneAndLanguageTwoSupplemental;
-(void)setLanguageTwoAndLanguageTwoSupplemental;
-(void)setLanguageOneAndLanguageTwoAndLanguageTwoSupplemental;
-(id)initWithDelegate:(id<CardDelegate>)theDelegate;
-(void)reloadData;
-(void)showResultsWithAmountCorrect:(unsigned int)amountCorrect andAmountIncorrect:(unsigned int)amountIncorrect andTotalItems:(unsigned int)totalItems andIncorrectItems:(NSArray *)incorrectItems;
-(void)studyAgain;
-(void)resetViewsWithoutAnimation;
@end
