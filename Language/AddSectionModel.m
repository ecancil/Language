//
//  AddSectionModel.m
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddSectionModel.h"

@implementation AddSectionModel
@synthesize sectionName;
static AddSectionModel *sharedInstance = nil;

+(AddSectionModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

-(void)clear{
    self.sectionName = nil;    
}

@end
