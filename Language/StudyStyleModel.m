//
//  StudyStyleModel.m
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudyStyleModel.h"
#import "UserDefaultUtil.h"
#import "UserPreferenceConstants.h"
#import "LocalizationStringConstants.h"

@implementation StudyStyleModel
@synthesize cardOrder = _cardOrder;
@synthesize cardOrderLabel = _cardOrderLabel;
@synthesize alphabetized = _alphabetized;
@synthesize randomized = _randomized;
@synthesize notSorted = _notSorted;
@synthesize answerTypeTyped = _answerTypeTyped;
@synthesize answerTypeNormal = _answerTypeNormal;


-(void)setAnswerTypeNormal:(BOOL)at{
    if(!at && !self.answerTypeTyped)return;
    //[self willChangeValueForKey:@"alphabetized"];
    _answerTypeNormal = at;
    if(at)[self setAnswerTypeNormalStyle];
    //[self didChangeValueForKey:@"alphabetized"];
}

-(void)setAnswerTypeTyped:(BOOL)at{
    if(!at && !self.answerTypeNormal)return;
    //[self willChangeValueForKey:@"alphabetized"];
    _answerTypeTyped = at;
    if(at)[self setAnswerTypeTypedStyle];
    //[self didChangeValueForKey:@"alphabetized"];
}

-(void)setNotSorted:(BOOL)s{
    if(!s && !self.alphabetized && !self.randomized)return;
    //[self willChangeValueForKey:@"alphabetized"];
    _notSorted = s;
    if(s)[self setNotSortedOrder];
    //[self didChangeValueForKey:@"alphabetized"];
}

-(void)setAlphabetized:(BOOL)a{
    if(!a && !self.notSorted && !self.randomized)return;
    //[self willChangeValueForKey:@"alphabetized"];
    _alphabetized = a;
    if(a)[self setAlphabetizedOrder];
    //[self didChangeValueForKey:@"alphabetized"];
}

-(void)setRandomized:(BOOL)r{
    if(!r && !self.notSorted && !self.alphabetized)return;
    //[self willChangeValueForKey:@"randomized"];
    _randomized = r;
    if(r)[self setRandomizedOrder];
   // [self didChangeValueForKey:@"randomized"];
}


-(void)setCardOrder:(NSString *)theOrder{
    if(theOrder == nil)return;
    [UserDefaultUtil setUserValueAsString:theOrder forKey:CARD_ORDER_KEY];
    _cardOrder = theOrder;
}

-(void)setCardAnswerStyle:(NSString *)theAnswerStyle{
    if(theAnswerStyle == nil)return;
    [UserDefaultUtil setUserValueAsString:theAnswerStyle forKey:CARD_ANSWER_TYPE_KEY];
//    _cardOrder = theAnswerStyle;
}

/*
-(void)setCardOrderLabel:(NSString *)theOrder{
    if(theOrder == nil)return;
    NSString *aLabel = NSLocalizedString(ALPHABETIZED_LABEL, nil);
    NSString *rLabel = NSLocalizedString(RANDOMIZED_LABEL, nil);
    if([theOrder isEqualToString: aLabel]){
        [self setAlphabetizedOrder];
    }else if([theOrder isEqualToString: rLabel]){
        [self setRandomizedOrder]; 
    }
    _cardOrderLabel = theOrder;
}
 */

-(void)setNotSortedOrder{
    self.randomized = NO;
    self.alphabetized = NO;
    [self setCardOrder:CARD_ORDER_VALUE_NOT_SORTED];
}

-(void)setRandomizedOrder{
    self.alphabetized = NO;
    self.notSorted = NO;
    [self setCardOrder:CARD_ORDER_VALUE_RANDOMIZED];
}
-(void)setAlphabetizedOrder{
    self.randomized = NO;
    self.notSorted = NO;
    [self setCardOrder:CARD_ORDER_VALUE_ALPHABETIZED];
}

-(void)setAnswerTypeNormalStyle{
    self.answerTypeTyped = NO;
    [self setCardAnswerStyle:CARD_ANSWER_TYPE_NORMAL];
}

-(void)setAnswerTypeTypedStyle{
    self.answerTypeNormal = NO;
    [self setCardAnswerStyle:CARD_ANSWER_TYPE_TYPED];
}

static StudyStyleModel *sharedInstance = nil;

+(StudyStyleModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
        sharedInstance.cardOrder = [UserDefaultUtil getUserValueAsStringForKey:CARD_ORDER_KEY];
        NSString *cardOrder = sharedInstance.cardOrder;
        if([sharedInstance.cardOrder isEqualToString:CARD_ORDER_VALUE_ALPHABETIZED]){
            [sharedInstance setAlphabetized:YES];
        }else if([sharedInstance.cardOrder isEqualToString:CARD_ORDER_VALUE_RANDOMIZED]){
            [sharedInstance setRandomized:YES];
        }else if([sharedInstance.cardOrder isEqualToString:CARD_ORDER_VALUE_NOT_SORTED]){
            [sharedInstance setNotSorted:YES];
        }
        else{
          [sharedInstance setAlphabetized:YES];  
        }
        
        NSString *answerStyle = sharedInstance.cardOrder = [UserDefaultUtil getUserValueAsStringForKey:CARD_ANSWER_TYPE_KEY];
        if([answerStyle isEqualToString:CARD_ANSWER_TYPE_TYPED]){
            [sharedInstance setAnswerTypeTyped:YES];
        }else if([answerStyle isEqualToString:CARD_ANSWER_TYPE_NORMAL]){
            [sharedInstance setAnswerTypeNormal:YES];
        }else{
            [sharedInstance setAnswerTypeNormal:YES];
        }
    }
    return sharedInstance;
}


@end
