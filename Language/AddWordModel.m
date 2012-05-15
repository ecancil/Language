//
//  AddWordModel.m
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddWordModel.h"
@interface AddWordModel ()

@end
@implementation AddWordModel
@synthesize language1 = _language1;
@synthesize language2 = _language2;
@synthesize language2Supplemental = _language2Supplemental;
@synthesize examples = _examples;
@synthesize word;

-(void)setLanguage1:(NSString *)language1{
    _language1 = language1;
   // if(word)word.language1 = language1;
}

-(void)setLanguage2:(NSString *)language2{
    _language2 = language2;
    //if(word)word.language2 = language2;
}

-(void)setLanguage2Supplemental:(NSString *)language2Supplemental{
    _language2Supplemental = language2Supplemental;
    //if(word)word.language2supplemental = language2Supplemental;
}

-(void)setExamples:(NSString *)examples{
    _examples = examples;
    //if(word)word.examples = examples;
}


static AddWordModel *sharedInstance = nil;

+(AddWordModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
-(AddWordModel *)clear{
    self.word = nil;
    self.language1 = self.language2 = self.language2Supplemental = self.examples = nil;
    return self;
}

-(void)updateValuesWithWord:(SQLWord *)theWord{
    self.word = nil;
    self.language1 = theWord.language1;
    self.language2 = theWord.language2;
    self.language2Supplemental = theWord.language2supplemental;
    self.examples = theWord.examples;
    self.word = theWord;
}

-(void)updateWordWithValuesAndImage:(UIImage *)theImage{
    self.word.language1 = self.language1;
    self.word.language2 = self.language2;
    self.word.language2supplemental = self.language2Supplemental;
    self.word.examples = self.examples;
    if(theImage)self.word.image = theImage;
}
@end
