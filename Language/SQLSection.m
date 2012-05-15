//
//  SQLSection.m
//  Demo
//
//  Created by Eric Cancil on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SQLSection.h"

@implementation SQLSection
@synthesize title;
@synthesize words;
@synthesize specialIdentifier;
@synthesize wordIDs;

-(id) init{
    if(self = [super init]){
        self.words = [[NSArray alloc] init];
    }
    return self;
}
@end
