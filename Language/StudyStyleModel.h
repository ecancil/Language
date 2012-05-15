//
//  StudyStyleModel.h
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudyStyleModel : NSObject

@property(nonatomic, retain) NSString *cardOrder;
@property(nonatomic, retain) NSString *cardOrderLabel;
@property(nonatomic, assign) BOOL alphabetized;
@property(nonatomic, assign) BOOL randomized;
@property(nonatomic, assign) BOOL notSorted;
@property(nonatomic, assign) BOOL answerTypeNormal;
@property(nonatomic, assign) BOOL answerTypeTyped;
-(void)setRandomizedOrder;
-(void)setAlphabetizedOrder;
-(void)setNotSortedOrder;
-(void)setAnswerTypeNormalStyle;
-(void)setAnswerTypeTypedStyle;
-(void)setCardAnswerStyle:(NSString *)theAnswerStyle;
+(StudyStyleModel *)getInstance;
@end
