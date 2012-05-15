//
//  Cache.m
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cache.h"
@interface Cache ()
@property (nonatomic, retain) NSMutableDictionary *topLevelCacheDictionary;
-(NSMutableDictionary *)getContextualDictionaryByContext:(NSString *)context;
@end
@implementation Cache
@synthesize topLevelCacheDictionary;

-(NSMutableDictionary *)getContextualDictionaryByContext:(NSString *)context{
    if(context == nil){
        [NSException raise:@"Context may not be nil" format:nil];
    }
    NSMutableDictionary *contextualDictionary;
    id contextLookup = [topLevelCacheDictionary objectForKey:context];
    if(contextLookup){
        contextualDictionary = contextLookup;
    }else{
        contextualDictionary = [[NSMutableDictionary alloc] init];
        [topLevelCacheDictionary setValue:contextualDictionary forKey:context];
    }
    return contextualDictionary;
}


-(void)addItemToCacheByKey:(NSString *)key forValue:(id)value inContext:(NSString *)context{
    NSMutableDictionary *contextualDictionary = [self getContextualDictionaryByContext:context];
    [contextualDictionary setValue:value forKey:key];
}

-(void)removeItemFromCacheByKey:(NSString *)key forValue:(id)value inContext:(NSString *)context{
     NSMutableDictionary *contextualDictionary = [self getContextualDictionaryByContext:context];
    [contextualDictionary removeObjectForKey:key];
}

-(id)getValueForKey:(NSString *)key inContext:(NSString *)context{
    NSMutableDictionary *contextualDictionary = [self getContextualDictionaryByContext:context];
    id value = [contextualDictionary objectForKey:key];
    return value;
}

-(void)addBulkItems:(NSArray *)items withSelectorKey:(SEL)selectorKey inContext:(NSString *)context withCompletion:(BulkAddDoneBlock)completionBlock{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         int i = 0;
         int count = items.count;
         for (i; i < count; i ++) {
             id foundObject = [items objectAtIndex:i];
             NSString *key = [NSString stringWithFormat:@"%@",[foundObject performSelector:selectorKey]];
             //NSLog(key);
             [self addItemToCacheByKey:key forValue:foundObject inContext:context];
         }
         completionBlock();
     });
}

static Cache *sharedInstance = nil;

+(Cache *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
        sharedInstance.topLevelCacheDictionary = [[NSMutableDictionary alloc] init];
    }
    return sharedInstance;
}

@end
