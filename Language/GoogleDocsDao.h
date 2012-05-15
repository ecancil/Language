//
//  GoogleDocsDao.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataEntrySpreadsheet.h"
#import "GoogleDocsDaoResponder.h"
#import "GDataEntryWorksheet.h"

@interface GoogleDocsDao : NSObject
-(id)initWithResponder:(id<GoogleDocsDaoResponder>)theResponder andUsername:(NSString *)theUsername andPassword:(NSString *)thePassword;
-(void)loginWithName:(NSString *)name password:(NSString *)password;
- (void)fetchFeedOfSpreadsheets;
- (void)fetchSpreadsheet:(GDataEntrySpreadsheet *)spreadsheet;
- (void)fetchWorksheet:(GDataEntryWorksheet *)worksheet;
@end
