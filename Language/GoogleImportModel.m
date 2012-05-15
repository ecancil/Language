//
//  GoogleImportModel.m
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleImportModel.h"
#import "SQLWord.h"

@implementation GoogleImportModel
@synthesize words;

static GoogleImportModel *sharedInstance = nil;

+(GoogleImportModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

-(void)addWordWithLanguage1:(NSString *)language1 language2:(NSString *)language2 langauge2Supplemental:(NSString *)language2Supplemental examples:(NSString *)examples{
    if(!language1 && !language2 && !language2Supplemental && !examples)return;
    if (!words) {
        words = [[NSMutableArray alloc] init];
    }
    SQLWord *word = [[SQLWord alloc] init];
    word.language1 = language1;
    word.language2 = language2;
    word.language2supplemental = language2Supplemental;
    word.examples = examples;
    
    [words addObject:word];
}
@end
