//
//  FormsBaseViewController.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "IBAFormViewController.h"

@interface FormsBaseViewController : IBAFormViewController

@property (nonatomic, retain) DaoInteractor *daoInteractor;

@end
