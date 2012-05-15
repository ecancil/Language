//
//  SecondaryListModel.m
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondaryListModel.h"

@implementation SecondaryListModel
@synthesize menuValues;
@synthesize activeUserSection;

static SecondaryListModel *sharedInstance = nil;

+(SecondaryListModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

@end
