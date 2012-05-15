//
//  WordsDAOImpl.h
//  Demo
//
//  Created by Eric Cancil on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordsDAO.h"
#import <sqlite3.h>

@interface WordsDAOImpl : NSObject <WordsDAO>{
    NSString *theDatabasePath;
    sqlite3 *db;
}
@property(nonatomic, retain) NSString * theDatabasePath;
@property(nonatomic, retain) NSString * tableName;

@end
