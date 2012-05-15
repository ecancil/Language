//
//  StudyReminderModel.h
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudyReminderModel : NSObject

@property(nonatomic, assign) BOOL recurDaily;
@property(nonatomic, retain) NSString *reminderTitle;
@property(nonatomic, retain) NSSet *sectionTitle;
@property(nonatomic, retain) NSNumber *sectionID;
@property(nonatomic, retain) NSDate *notificationDate;
@property(nonatomic, retain) NSArray *allNotifications;
@property(nonatomic, retain) UILocalNotification *toDelete;
+(StudyReminderModel *)getInstance;
-(void)saveCurrentItem;
-(void)clear;
-(void)deleteNotification:(UILocalNotification *)notification;
@end
