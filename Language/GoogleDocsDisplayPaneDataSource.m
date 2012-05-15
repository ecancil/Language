//
//  GoogleDocsDisplayPaneDataSource.m
//  Language
//
//  Created by Eric Cancil on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleDocsDisplayPaneDataSource.h"
#import "IBATextFormField.h"
#import "IBATextFormField+Factory.h"
#import "GoogleLoginModel.h"
#import "IBAButtonFormField.h"
#import "CenteredButtonStyle.h"
#import "NotificationConstants.h"
#import "KeychainUtil.h"
#import "IBAInputManager.h"

@interface GoogleDocsDisplayPaneDataSource ()
-(void)displayForm;
-(void)addVerifyField;
@property (nonatomic, retain) IBAFormSection *formSection;
@property (nonatomic, retain) IBATextFormField *emailTextFormField;
@property (nonatomic, retain) IBATextFormField *passwordTextFormField;
@property (nonatomic, retain) IBAButtonFormField *verifyField;
@property (nonatomic, retain) GoogleDocsDao *gDao;
@end
@implementation GoogleDocsDisplayPaneDataSource
@synthesize formSection;
@synthesize emailTextFormField;
@synthesize passwordTextFormField;
@synthesize verifyField;
@synthesize gDao;

-(id)initWithModel:(id)model{
    self = [super initWithModel:model];
    [self displayForm];
    
    NSString *email = [KeychainUtil load:@"email"];
    NSString *password = [KeychainUtil load:@"password"];
    
    self.gDao = [[GoogleDocsDao alloc] initWithResponder:self andUsername:email andPassword:password];
    return self;
}

-(void)clearFields{
    [emailTextFormField setFormFieldValue:@""];
    [passwordTextFormField setFormFieldValue:@""];
}

-(void)displayForm{
    GoogleLoginModel *model = (GoogleLoginModel *)self.model;
    NSString *email = [KeychainUtil load:@"email"];
    NSString *password = [KeychainUtil load:@"password"];
    
    if (email && password) {
        model.email = email;
        model.password = password;
    }
    
    formSection = [self addSectionWithHeaderTitle:@"GMAIL" footerTitle:nil];
    
    emailTextFormField = [IBATextFormField emailTextFormFieldWithSection:formSection keyPath:@"email" title:@"Gmail :" valueTransformer:nil];
    
    [emailTextFormField setDelegate:self];
    
    passwordTextFormField = [IBATextFormField passwordTextFormFieldWithSection:formSection keyPath:@"password" title:@"Password :" valueTransformer:nil];
    
    [passwordTextFormField setDelegate:self];
    
    [self addVerifyField];
    

}

-(void)addVerifyField{
    GoogleLoginModel *model = (GoogleLoginModel *)self.model;
    self.verifyField = [[IBAButtonFormField alloc] initWithTitle:@"Verify and Save" icon:nil executionBlock:^{
        [[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:STARTED_VERIFYING_GMAIL object:self];
        [gDao loginWithName:model.email password:model.password];
    }];
    [self.verifyField setFormFieldStyle:[[CenteredButtonStyle alloc] init]];
    [formSection addFormField:self.verifyField];
}

-(void)didLogin{
    GoogleLoginModel *model = (GoogleLoginModel *)self.model;
    [KeychainUtil save:@"email" data:model.email];
    [KeychainUtil save:@"password" data:model.password];
    [[NSNotificationCenter defaultCenter] postNotificationName:GMAIL_LOGIN_SUCCESS object:self];
}
-(void)loginDidReturnError{
    [[NSNotificationCenter defaultCenter] postNotificationName:GMAIL_LOGIN_ERROR object:self];
}


@end
