//
//  StudyRemindersPreferencePane.m
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudyRemindersPreferencePane.h"
#import "StudyReminderModel.h"
#import "StyledTableCell.h"
#import "StudyReminderDataSource.h"
#import "CreateStudyReminder.h"
#import "AssetConstants.h"
@interface StudyRemindersPreferencePane ()
@property (nonatomic, retain) StudyReminderModel *model;
-(void)determineEdit;
@end
@implementation StudyRemindersPreferencePane
@synthesize tableView;
@synthesize model;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    model = [StudyReminderModel getInstance];
    
   // NSUInteger theCount = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self determineEdit];
}

-(void)determineEdit{
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Reminder" style:UIBarButtonItemStylePlain target:self action:@selector(onCreate)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit)];
    if(model.allNotifications.count > 0){
        [self.navigationItem setRightBarButtonItems:[[NSArray alloc] init]];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:createButton, editItem, nil] animated:YES];
    }else{
        [self.navigationItem setRightBarButtonItems:[[NSArray alloc] init]];
        [self.navigationItem setRightBarButtonItem:createButton animated:YES];
    }
}

-(void)onEdit{
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Reminder" style:UIBarButtonItemStylePlain target:self action:@selector(onCreate)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDone)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:createButton, doneItem, nil] animated:YES];

    [self.tableView setEditing:YES animated:YES];
}

-(void)onDone{
    [self.tableView setEditing:NO animated:YES];
    [self determineEdit];
}

-(void)onCreate{
    model.recurDaily = YES;
    CreateStudyReminder *create = [[CreateStudyReminder alloc] initWithFormDataSource:[[StudyReminderDataSource alloc] initWithModel:[StudyReminderModel getInstance]]];
    [self.navigationController pushViewController:create animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[model allNotifications] count];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView reloadData];
    [self.model setToDelete:nil];
    //[self determineEdit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       // cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    int row = indexPath.row;
    [cell.imageView setImage:NOTIFICATION_ASSET];
    UILocalNotification *notification = [self.model.allNotifications objectAtIndex:row];
    cell.textLabel.text = notification.alertBody;
    
    
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    UILocalNotification *notification = [[model allNotifications] objectAtIndex:row];
    [model setToDelete:notification];
    CreateStudyReminder *create = [[CreateStudyReminder alloc] initWithFormDataSource:[[StudyReminderDataSource alloc] initWithModel:model]];
    [self.navigationController pushViewController:create animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    NSArray *all = [model allNotifications];
    UILocalNotification * notification = [all objectAtIndex:row];
    [model deleteNotification:notification];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
