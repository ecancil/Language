//
//  CreateGroupDataSource.m
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateGroupDataSource.h"
#import "AddSectionModel.h"
@interface CreateGroupDataSource ()
@property(nonatomic, retain) IBAFormSection *formSection;
@property(nonatomic, retain) IBATextFormField *sectionName;
@property(nonatomic, retain) AddSectionModel *typedModel;
-(void)displayForm;
@end
@implementation CreateGroupDataSource
@synthesize formSection;
@synthesize sectionName;
@synthesize typedModel;
@synthesize shouldShowSaveButton;

-(id)initWithModel:(id)model{
    self = [super initWithModel:model];
    self.typedModel = self.model;
    [self displayForm];
    return self;
}



-(void)displayForm{   
    formSection = [self addSectionWithHeaderTitle:@"Section" footerTitle:nil];
    
    sectionName = [[IBATextFormField alloc] initWithKeyPath:@"sectionName" title:@"Title"];
    
    
    [formSection addFormField:sectionName];
    
    
    [sectionName.textFormFieldCell.textField addTarget:self action:@selector(onChanged) forControlEvents:UIControlEventEditingChanged];
}

-(void)onChanged{
    if (sectionName.textFormFieldCell.textField.text.length > 0) {
        self.shouldShowSaveButton = YES;
    }else{
        self.shouldShowSaveButton = NO;
    }
}


@end
