//
//  GoogleDocsDisplayPaneDataSource.h
//  Language
//
//  Created by Eric Cancil on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBAFormDataSource.h"
#import "GoogleDocsDaoResponder.h"
#import "GoogleDocsDao.h"


@interface GoogleDocsDisplayPaneDataSource : IBAFormDataSource <IBAFormFieldDelegate, GoogleDocsDaoResponder>
-(void)clearFields;
@end
