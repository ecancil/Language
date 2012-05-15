//
//  FlashcardEnumerations.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashcardEnumerations : NSObject
enum{
    OnlyLanguageOne = -1,
    OnlyLanguageTwo = 1,
    OnlyLanguageTwoSupplemental = 2,
    OnlyPhoto = 3,
    LanguageOneAndLanguageTwo = 4,
    LanguageOneAndLanguageTwoSupplemental = 5,
    LanguageTwoAndLanguageTwoSupplemental = 6,
    LanguageOneAndLanguageTwoAndLanguageTwoSupplemental = 7
};
@end