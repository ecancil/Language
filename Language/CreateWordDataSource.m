//
//  CreateWordDataSource.m
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateWordDataSource.h"
#import "IBATextFormField.h"
#import "CenteredButtonStyle.h"
#import "AddWordModel.h"

@interface CreateWordDataSource ()
@property(nonatomic, retain) AddWordModel *addWordModel;
@end

@implementation CreateWordDataSource
@synthesize language1Field;
@synthesize language2Field;
@synthesize language2SupplementalField;
@synthesize addExamplesButtonField;
@synthesize viewDelegate;
@synthesize shouldShowSaveButton;
@synthesize addWordModel;

-(id)initWithModel:(id)model{
    self = [super initWithModel:model];
    addWordModel = model;
    [self displayForm];
    return self;
}

-(void)displayForm{
    
    IBAFormSection *formSection = [self addSectionWithHeaderTitle:@"Add a word" footerTitle:nil];
    
    language1Field = [[IBATextFormField alloc] initWithKeyPath:@"language1" title:NSLocalizedString(@"language1", nil)];
    language2Field = [[IBATextFormField alloc] initWithKeyPath:@"language2" title:NSLocalizedString(@"language2", nil)];
    language2SupplementalField = [[IBATextFormField alloc] initWithKeyPath:@"language2Supplemental" title:NSLocalizedString(@"language2supplemental", nil)];
    addExamplesButtonField = [[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"examples", nil) icon:nil executionBlock:^{
        if(viewDelegate != nil){
            [viewDelegate didAddExample];
        }
        
    }];
    
    [addExamplesButtonField setFormFieldStyle:[[CenteredButtonStyle alloc] init]];
    
    [formSection addFormField:language1Field];
    [formSection addFormField:language2Field];
    [formSection addFormField:language2SupplementalField];
    [formSection addFormField:addExamplesButtonField];
    
    [self.language1Field.textFormFieldCell.textField addTarget:self action:@selector(onChange) forControlEvents:UIControlEventEditingChanged];
    [self.language2Field.textFormFieldCell.textField addTarget:self action:@selector(onChange) forControlEvents:UIControlEventEditingChanged];
    
    [self performSelector:@selector(onChange)];
}

-(void)onChange{
    if(self.addWordModel.language1.length > 0){// && self.self.addWordModel.language2.length > 0){
        self.shouldShowSaveButton = YES;
    }else{
        self.shouldShowSaveButton = NO;
    }
}

@end
