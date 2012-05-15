//
//  UserDefaultUtil.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDefaultUtil : NSObject

+(void)setUserValueAsInteger:(int)value forKey:(NSString *)key;
+(void)setUserValueAsString:(NSString *)value forKey:(NSString *)key;
+(int)getUserValueAsIntegerForKey:(NSString *)key;
+(NSString *)getUserValueAsStringForKey:(NSString *)key;
@end
