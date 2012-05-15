//
//  GoogleLoginModel.m
//  Language
//
//  Created by Eric Cancil on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleLoginModel.h"

@implementation GoogleLoginModel
@synthesize email;
@synthesize password;

static GoogleLoginModel *sharedInstance = nil;

+(GoogleLoginModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
@end
