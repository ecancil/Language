//
//  StudyReminderModel.m
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudyReminderModel.h"
#import "LocalPushUtil.h"
#import "ManagedObjectsDao.h"
#import "DaoInteractor.h"


@implementation StudyReminderModel
@synthesize recurDaily;
@synthesize reminderTitle;
@synthesize sectionTitle = _sectionTitle;
@synthesize sectionID;
@synthesize notificationDate;
@synthesize allNotifications;
@synthesize toDelete = _toDelete;
static StudyReminderModel *sharedInstance = nil;

-(void)setSectionTitle:(NSSet *)theTitle{
    NSString *theStringTitle = [[theTitle.allObjects objectAtIndex:0] performSelector:@selector(description)];
    if(!theStringTitle)return;
    NSArray *rows = [DaoInteractor getInstance].allUserCreatedSections;
    for (int i = 0; i < rows.count; i ++) {
        Section *section = [rows objectAtIndex:i];
        NSString *sectionTitle = section.title;
        if([sectionTitle isEqualToString:theStringTitle]){
            [self setSectionID:section.uniqueID];
        }
    }
    _sectionTitle = theTitle;
}

-(void)setToDelete:(UILocalNotification *)toDeleteItem{
    self.recurDaily = (toDeleteItem.repeatInterval != 0);
    self.reminderTitle = toDeleteItem.alertBody;
    self.sectionID = [toDeleteItem.userInfo valueForKey:@"sectionID"];
    self.notificationDate = toDeleteItem.fireDate;
    _toDelete = toDeleteItem;
}

+(StudyReminderModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
        sharedInstance.allNotifications = [LocalPushUtil getAllNotifications];
    }
    return sharedInstance;
}

-(void)clear{
    self.recurDaily = NO;
    self.reminderTitle  = nil;
}

-(void)saveCurrentItem{
    [LocalPushUtil addNotificationWithMessage:reminderTitle andDate:notificationDate doesRecur:self.recurDaily withSection:sectionID];
    if(self.toDelete){
        [self deleteNotification:self.toDelete];
        _toDelete = nil;
    }
    allNotifications = [LocalPushUtil getAllNotifications];
}

-(void)deleteNotification:(UILocalNotification *)notification{
   [LocalPushUtil removeNotification:notification]; 
    self.allNotifications = [LocalPushUtil getAllNotifications];
    
}

@end
