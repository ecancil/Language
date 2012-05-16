//
//  StudyReminderDataSource.m
//  Language
//
//  Created by Eric Cancil on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudyReminderDataSource.h"
#import "IBAFormSection.h"
#import "IBABooleanSwitchCell.h"
#import "IBABooleanFormField.h"
#import "ManagedObjectsDao.h"
#import "StudyReminderModel.h"

#import <IBAForms/IBAForms.h>
@interface StudyReminderDataSource ()
-(void)displayForm;
-(NSArray *)getActionSheetRows;
@property (nonatomic, retain) IBAFormSection *formSection;
@property (nonatomic, retain) IBABooleanFormField *recurDaily;
@property (nonatomic, retain) IBATextFormField *reminderTitle;
@property (nonatomic, retain) IBAPickListFormField *sectionPickList;
@property (nonatomic, retain) StudyReminderModel *typedModel;
@property (nonatomic, retain) ManagedObjectsDao *moDao;

@end

@implementation StudyReminderDataSource
@synthesize formSection;
@synthesize recurDaily;
@synthesize reminderTitle;
@synthesize typedModel;
@synthesize moDao;
@synthesize sectionPickList;

-(id)initWithModel:(id)model{
    self = [super initWithModel:model];
    self.moDao = [ManagedObjectsDao getInstance];
    self.typedModel = self.model;
    if(!typedModel.toDelete)[self.typedModel clear];
    [self displayForm];
    return self;
}



-(void)displayForm{   
    
    formSection = [self addSectionWithHeaderTitle:@"" footerTitle:nil];
    
    reminderTitle = [[IBATextFormField alloc] initWithKeyPath:@"reminderTitle" title:@"Message"];
    
    
    
    recurDaily = [[IBABooleanFormField alloc] initWithKeyPath:@"recurDaily" title:@"Recur Daily" type:IBABooleanFormFieldTypeSwitch];
    
    
    [self.formSection addFormField:reminderTitle];
    [self.formSection addFormField:self.recurDaily];
    
    
    
    if([[self getActionSheetRows] count] > 0){

        sectionPickList = [[IBAPickListFormField alloc] initWithKeyPath:@"sectionTitle" title:@"Section" valueTransformer:nil selectionMode:IBAPickListSelectionModeSingle options:[IBAPickListFormOption pickListOptionsForStrings:[self getActionSheetRows]]];
        [self.sectionPickList setDelegate:self]; 
        [self.formSection addFormField:sectionPickList];
    }
    
}

-(NSArray *)getActionSheetRows{
    NSArray *allUserSections = [self.daoInteractor getSanitizedUserCreatedSections];
    NSMutableArray *toReturn  = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < allUserSections.count; i ++) {
        Section *section = (Section *)[allUserSections objectAtIndex:i];
        if(section.title){
            [toReturn addObject:section.title];  
        }
    }
    return toReturn.copy;
}
@end
