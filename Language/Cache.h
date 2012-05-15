//
//  Cache.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject
//typedef void(^BulkAddDoneBlock)(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue);
typedef void(^BulkAddDoneBlock)();


-(void)addItemToCacheByKey:(NSString *)key forValue:(id)value inContext:(NSString *)context;
-(void)removeItemFromCacheByKey:(NSString *)key forValue:(id)value inContext:(NSString *)context;
-(id)getValueForKey:(NSString *)key inContext:(NSString *)context;
-(void)addBulkItems:(NSArray *)items withSelectorKey:(SEL)selectorKey inContext:(NSString *)context withCompletion:(BulkAddDoneBlock)completionBlock;
+(Cache *)getInstance;
@end
