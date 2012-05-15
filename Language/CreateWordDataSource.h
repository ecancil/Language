//
//  CreateWordDataSource.h
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAFormDataSource.h"
#import "IBAForms.h"
#import "CreateWord.h"

@interface CreateWordDataSource : IBAFormDataSource
-(void)displayForm;

@property(nonatomic, retain)IBATextFormField *language1Field;
@property(nonatomic, retain)IBATextFormField *language2Field;
@property(nonatomic, retain)IBATextFormField *language2SupplementalField;
@property(nonatomic, retain)IBAButtonFormField *addExamplesButtonField;
@property(nonatomic, assign)CreateWord *viewDelegate;
@property(nonatomic, assign) BOOL shouldShowSaveButton;
@end
