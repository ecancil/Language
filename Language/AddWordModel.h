//
//  AddWordModel.h
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLWord.h"
#import "Section.h"
#import "Word.h"

@interface AddWordModel : NSObject


@property(nonatomic, retain) NSString *language1;
@property(nonatomic, retain) NSString *language2;
@property(nonatomic, retain) NSString *language2Supplemental;
@property(nonatomic, retain) NSString *examples;
@property (nonatomic, retain) SQLWord *word;
@property (nonatomic, retain) id image;
//kinda an ugly hack
@property (nonatomic, assign) BOOL popAgain;
@property (nonatomic, assign) BOOL isClone;


+(AddWordModel *)getInstance;
-(AddWordModel *)clear;
-(void)updateValuesWithWord:(Word *)theWord;
-(void)updateWordWithValuesAndImage:(UIImage *)theImage;
@end
