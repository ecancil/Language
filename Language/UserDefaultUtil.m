//
//  UserDefaultUtil.m
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDefaultUtil.h"

@implementation UserDefaultUtil
+(void)setUserValueAsInteger:(int)value forKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // set the value
    [defaults setInteger:value forKey:key];
    
    // save it
    [defaults synchronize];
}

+(void)setUserValueAsString:(NSString *)value forKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // set the value
    [defaults setObject:value forKey:key];
    
    // save it
    [defaults synchronize];
}

+(int)getUserValueAsIntegerForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
   
    
    NSInteger retrievedValue = [defaults integerForKey:key]; 
    return retrievedValue;
}
                
+(NSString *)getUserValueAsStringForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    
    
    NSString *retrievedValue = [defaults stringForKey:key]; 
    return retrievedValue;                    
}
@end
