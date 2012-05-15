//
//  WordsDAO.h
//  Demo
//
//  Created by Eric Cancil on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordsDAO.h"

@protocol WordsDAO <NSObject>
@required
-(id<WordsDAO>)initWithDatabasePath:(NSString *)thePath;
-(NSArray *)retrieveAllContentsFromTable:(NSString *)theTableName;
-(NSArray *)retrieveAllContentsBySectionName:(NSString *)sectionName FromTable:(NSString *)theTableName;
-(NSArray *)retrieveDistinctItemsByColumnName:(NSString *)columnName FromTable:(NSString *)theTableName;
-(NSArray *)retrieveAllContentsbyKeyword:(NSString *)keyword fromTable:(NSString *)theTableName;
-(NSArray *)retrieveAllContentsbyKeywords:(NSArray *)keywords fromTable:(NSString *)theTableName;
@end
