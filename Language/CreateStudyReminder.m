//
//  CreateStudyReminder.m
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateStudyReminder.h"
#import "StudyReminderModel.h"
#import "IBAInputManager.h"
@interface CreateStudyReminder ()
@property(nonatomic, retain) StudyReminderModel *model;
@end

@implementation CreateStudyReminder
@synthesize tableView;
@synthesize timePicker;
@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [StudyReminderModel getInstance];
    if(model.toDelete){
        [self.timePicker setDate:model.notificationDate animated:YES];
    }else{
        model.notificationDate = timePicker.date;
    }
    
    [self.timePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
     
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSave:)];
    
    [self.navigationItem setRightBarButtonItem:saveItem];
}

-(void)onDateChange:(id)event{
    model.notificationDate = timePicker.date;
}

-(void)onSave:(id)sender{
    [[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil];
    [model saveCurrentItem];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTimePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
