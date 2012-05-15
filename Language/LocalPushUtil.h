//
//  LocalPushUtil.h
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Section.h"

@interface LocalPushUtil : NSObject
+(void)addNotificationWithMessage:(NSString *)message andDate:(NSDate *)date doesRecur:(BOOL)doesRecur withSection:(NSNumber *)section;
+(void)removeNotification:(UILocalNotification *)notification;
+(NSArray *)getAllNotifications;
@end
