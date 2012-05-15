//
//  Word+Word_Initializer.m
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Word+Word_Initializer.h"

@implementation Word (Word_Initializer)
-(Word *)initwithSqlWord:(SQLWord *)sqlWord{
    if([super init]){
        self.language1 = sqlWord.language1;
        self.language2 = sqlWord.language2;
        self.language2supplemental = sqlWord.language2supplemental;
        self.section = sqlWord.section;
    }
    return self;
}
@end
