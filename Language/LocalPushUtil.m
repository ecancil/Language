//
//  LocalPushUtil.m
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalPushUtil.h"


@implementation LocalPushUtil
+(void)addNotificationWithMessage:(NSString *)message andDate:(NSDate *)date doesRecur:(BOOL)doesRecur withSection:(NSNumber *)section{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if(doesRecur)notification.repeatInterval = NSDayCalendarUnit;
    NSDate *earlierDate = [date earlierDate:[NSDate date]];
    NSDate *dateToSet;
    if(earlierDate == date ){
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        NSCalendar *cal = [NSCalendar currentCalendar];
        [cal setTimeZone:[NSTimeZone systemTimeZone]];
        dateToSet = [cal dateByAddingComponents:offsetComponents toDate:earlierDate options:0];
    }else{
        dateToSet = date; 
    }
    notification.fireDate = dateToSet;
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    if(section){
        NSDictionary *infoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:section, @"sectionID", nil];
        notification.userInfo = infoDictionary;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

+(void)removeNotification:(UILocalNotification *)notification{
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

+(NSArray *)getAllNotifications{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    return allNotifications;
}
@end
