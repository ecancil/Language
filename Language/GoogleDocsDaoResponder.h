//
//  GoogleDocsDaoResponder.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataFeedWorksheet.h"

@protocol GoogleDocsDaoResponder <NSObject>
@optional
-(void)didFetchSpreadsheets:(NSArray *)spreadsheets;
-(void)didFetchWorksheets:(NSArray *)worksheets;
-(void)didFetchEntries:(NSArray *)entries;
-(void)didLogin;
-(void)loginDidReturnError;
@end
