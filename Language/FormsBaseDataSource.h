//
//  FormsBaseDataSource.h
//  Language
//
//  Created by Eric Cancil on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBAFormDataSource.h"
#import "DaoInteractor.h"

@interface FormsBaseDataSource : IBAFormDataSource
@property(nonatomic, retain) DaoInteractor *daoInteractor;
@end
