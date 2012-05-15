//
//  WordsDAOImpl.m
//  Demo
//
//  Created by Eric Cancil on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WordsDAOImpl.h"
#import <sqlite3.h>
#import "SQLWord.h"
#import "SQLSection.h"
#import "WordCache.h"
@interface WordsDAOImpl ()
- (void) setup;

@end
@implementation WordsDAOImpl
@synthesize theDatabasePath;
@synthesize tableName;



-(id<WordsDAO>)initWithDatabasePath:(NSString *)thePath{
    if([super init]){
        self.theDatabasePath = thePath;
        [self setup];
    }
    return self;
}

-(void)setup{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"words.sqlite"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    if(!success){
        NSLog(@"Cannot locate database file '%@' ", dbPath);
    }
    if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)){
        NSLog(@"An error has occured: %@", sqlite3_errmsg(db));
    }

    
}

-(NSArray *)retrieveAllContentsFromTable:(NSString *)theTableName{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:nil, nil];
    sqlite3_stmt *sqlStatement;
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM %@", theTableName];
    const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
    //const char *sql = "SELECT * from test";
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        char *err = sqlite3_errmsg(db);
        NSLog(@"There is a problem in prepare");
    }else{
        while(sqlite3_step(sqlStatement) == SQLITE_ROW){
            SQLWord *theWord = [[SQLWord alloc] init];
            theWord.uniqueID = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)];
            theWord.language1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
             theWord.language2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
             theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)];
            theWord.section = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
            //theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 5)];
            [arr addObject:theWord];
        }
    }
    sqlite3_finalize(sqlStatement);
    return [arr copy];
}

-(NSArray *)retrieveAllContentsBySectionName:(NSString *)sectionName FromTable:(NSString *)theTableName{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:nil, nil];
     NSString *s = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE section is '%@'", theTableName, sectionName];
    const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt * sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"There is a problem in prepare");
    }else{
        while(sqlite3_step(sqlStatement) == SQLITE_ROW){
            SQLWord *theWord = [[SQLWord alloc] init];
            theWord.uniqueID = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)];
            theWord.language1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
            theWord.language2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
             theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)]; 
            theWord.section = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)]; 
           // theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 5)]; 
            [arr addObject:theWord];
        }
    }
    sqlite3_finalize(sqlStatement);
    return [arr copy];
}

-(NSArray *)retrieveDistinctItemsByColumnName:(NSString *)columnName FromTable:(NSString *)theTableName{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:nil, nil];
    NSString *s = [NSString stringWithFormat:@"SELECT DISTINCT %@, %@ FROM %@", columnName, columnName, theTableName];
    const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt * sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"There is a problem in prepare");
    }else{
        while(sqlite3_step(sqlStatement) == SQLITE_ROW){
            SQLSection *theSection;
            theSection = [[SQLSection alloc] init];
             //theSection.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
             theSection.title = ((char *)sqlite3_column_text(sqlStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)] : nil;

             [arr addObject:theSection];
        }
    }
    sqlite3_finalize(sqlStatement);
    return [arr copy];
}

-(NSArray *)retrieveAllContentsbyKeyword:(NSString *)keyword fromTable:(NSString *)theTableName{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:nil, nil];
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE language1 like '%@%@%@' or language2 like '%@%@%@'", theTableName, @"%",keyword, @"%", @"%", keyword, @"%"];
    const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt * sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"There is a problem in prepare");
    }else{
        while(sqlite3_step(sqlStatement) == SQLITE_ROW){
            SQLWord *theWord = [[SQLWord alloc] init];
            theWord.uniqueID = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)];
            theWord.language1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
            theWord.language2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
             theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)]; 
            //theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 5)];
            [arr addObject:theWord];
        }
    }
    sqlite3_finalize(sqlStatement);
    return [arr copy];

}

-(NSArray *)retrieveAllContentsbyKeywords:(NSArray *)keywords fromTable:(NSString *)theTableName{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:nil, nil];
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ", theTableName];
                   //language1 like '%@%@%@' or language2 like '%@%@%@'", theTableName, @"%",keyword, @"%", @"%", keyword, @"%"];
    int i;
    NSString *allParts = [[NSString alloc] init];
    for(i = 0; i < keywords.count; i ++){
        NSString *keyword = (NSString *)[keywords objectAtIndex:i];
        if(keyword){
            NSString *part = [NSString stringWithFormat:@"language1 like '%%%@%%' OR language2 like '%%%@%%'", keyword, keyword];
            allParts = [allParts stringByAppendingString:part];
            if(i != keywords.count - 1){
                allParts = [allParts stringByAppendingString:@" OR "];
            }
            s = [s stringByAppendingString:allParts];
        }
    }
    const char *sql = [s cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt * sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        char *error = sqlite3_errmsg(db);
        NSLog(@"There is a problem in prepare");
    }else{
        while(sqlite3_step(sqlStatement) == SQLITE_ROW){
            SQLWord *theWord = [[SQLWord alloc] init];
            theWord.uniqueID = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)];
            theWord.language1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
            theWord.language2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
             theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
            //theWord.language2supplemental = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 5)];
            [arr addObject:theWord];
        }
    }
    sqlite3_finalize(sqlStatement);
    return [arr copy];
}
@end
