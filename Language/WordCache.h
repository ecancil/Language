//
//  WordCache.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
#import "Cache.h"

#define WORD_CONTEXT @"wordContext"

@interface WordCache : NSObject
+(void)addWordToCacheByKey:(NSNumber *)key forValue:(Word *)word;
+(void)removeWordFromCacheByKey:(NSNumber *)key forValue:(Word *)word;
+(Word *)getWordForKey:(NSNumber *)key;
+(void)addBulkWords:(NSArray *)words withCompletion:(BulkAddDoneBlock)completionBlock;
@end
