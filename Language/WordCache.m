//
//  WordCache.m
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WordCache.h"


@implementation WordCache
+(void)addWordToCacheByKey:(NSNumber *)key forValue:(Word *)word{
    NSString *realKey = [NSString stringWithFormat:@"%@", key];
    [[Cache getInstance] addItemToCacheByKey:realKey forValue:word inContext:WORD_CONTEXT];
}
+(void)removeWordFromCacheByKey:(NSNumber *)key forValue:(Word *)word{
    NSString *realKey = [NSString stringWithFormat:@"%@", key];
    [[Cache getInstance] removeItemFromCacheByKey:realKey forValue:word inContext:WORD_CONTEXT];
}
+(Word *)getWordForKey:(NSNumber *)key{
    NSString *realKey = [NSString stringWithFormat:@"%@", key];
    return (Word *)[[Cache getInstance] getValueForKey:realKey inContext:WORD_CONTEXT];
}
+(void)addBulkWords:(NSArray *)words withCompletion:(BulkAddDoneBlock)completionBlock{
    [[Cache getInstance] addBulkItems:words withSelectorKey:@selector(uniqueID) inContext:WORD_CONTEXT withCompletion:completionBlock];
}
@end
