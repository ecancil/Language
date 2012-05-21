//
//  StudyStyleDataSource.m
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudyStyleDataSource.h"
#import "LocalizationStringConstants.h"
#import "IBABooleanFormField.h"
@interface StudyStyleDataSource ()
-(void)displayForm;
@property (nonatomic, retain) IBAFormSection *sortFormSection;
@property (nonatomic, retain) IBABooleanFormField *alphCheck;
@property (nonatomic, retain) IBABooleanFormField *ranCheck;
@property (nonatomic, retain) IBABooleanFormField *notSortedCheck;
@property (nonatomic, retain) IBAFormSection *answerTypeFormSection;
@property (nonatomic, retain) IBABooleanFormField *normalCheck;
@property (nonatomic, retain) IBABooleanFormField *typeCheck;
@end
@implementation StudyStyleDataSource
@synthesize sortFormSection;
@synthesize alphCheck;
@synthesize ranCheck;
@synthesize notSortedCheck;
@synthesize answerTypeFormSection;
@synthesize normalCheck;
@synthesize typeCheck;

-(id)initWithModel:(id)model{
    self = [super initWithModel:model];
    [self displayForm];
    return self;
}



-(void)displayForm{ 
    //cardOrderLabel
    
    sortFormSection = [self addSectionWithHeaderTitle:NSLocalizedString(CARD_ORDER_SECTION_TITLE_LABEL, nil) footerTitle:nil];
    
    
    alphCheck = [[IBABooleanFormField alloc] initWithKeyPath:@"alphabetized" title:NSLocalizedString(ALPHABETIZED_LABEL, nil) type:IBABooleanFormFieldTypeCheck];
    
    ranCheck = [[IBABooleanFormField alloc] initWithKeyPath:@"randomized" title:NSLocalizedString(RANDOMIZED_LABEL, nil) type:IBABooleanFormFieldTypeCheck];
    
    notSortedCheck = [[IBABooleanFormField alloc] initWithKeyPath:@"notSorted" title:NSLocalizedString(NO_SORT_LABEL, nil) type:IBABooleanFormFieldTypeCheck];
    
    [self.sortFormSection addFormField:alphCheck];
    
    [self.sortFormSection addFormField:ranCheck];
    
    [self.sortFormSection addFormField:notSortedCheck];
    
    
    answerTypeFormSection = [self addSectionWithHeaderTitle:NSLocalizedString(ANSWER_TYPE_SECTION_TITLE_LABEL, nil) footerTitle:nil];
    
    
    normalCheck = [[IBABooleanFormField alloc] initWithKeyPath:@"answerTypeNormal" title:NSLocalizedString(NORMAL_LABEL, nil) type:IBABooleanFormFieldTypeCheck];
    
    typeCheck = [[IBABooleanFormField alloc] initWithKeyPath:@"answerTypeTyped" title:NSLocalizedString(TYPED_LABEL, nil) type:IBABooleanFormFieldTypeCheck];
    
    [self.answerTypeFormSection addFormField:normalCheck];
    
    [self.answerTypeFormSection addFormField:typeCheck];
    
    
}

@end
