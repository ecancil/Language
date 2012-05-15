//
//  GoogleImportModel.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleImportModel : NSObject

@property (nonatomic, retain) NSMutableArray *words;

+(GoogleImportModel *)getInstance;

-(void)addWordWithLanguage1:(NSString *)language1 language2:(NSString *)language2 langauge2Supplemental:(NSString *)language2Supplemental examples:(NSString *)examples;
@end
