//
//  Section+Section_Section_Initializer.m
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Section+Section_Section_Initializer.h"

@implementation Section (Section_Section_Initializer)
-(id)initWithSqlSection:(SQLSection *) sqlSection{
    if([super init]){
        self.title = sqlSection.title;
    }
    return self;
}

-(id)initWithTitle:(NSString *) title{
    if([super init]){
        self.title = title;
    }
    return self;
}
@end
