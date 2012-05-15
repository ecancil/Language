//
//  Word+Word_Initializer.h
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Word.h"
#import "SQLWord.h"

@interface Word (Word_Initializer)
-(Word *)initwithSqlWord:(SQLWord *)sqlWord;
@end
