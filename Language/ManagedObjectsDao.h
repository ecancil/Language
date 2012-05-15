//
//  ManagedObjectsDao.h
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
#import "Section.h"
#import "SQLWord.h"
#import "AnswerTally.h"

@interface ManagedObjectsDao : NSObject {
    
    
}
@property(nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic, retain) UIManagedDocument *document;
@property(nonatomic, retain) Section *defaultWordBank;
@property(nonatomic, retain) NSArray *allWords;

//fixed methods
-(void)addWordToDefaultWordBank:(Word *)word;
-(Section *)retrieveUserWordsSection;
-(Section *)retrieveDefaultWordBank;
-(Section *)addNewSectionByTitle:(NSString *)title;
-(Section *)addNewSectionByTitle:(NSString *)title withWords:(NSArray *)words;
-(NSArray *)retrieveAllUserCreatedSections;
-(void)addWord:(Word *)word ToSection:(Section *)section;
-(void)eraseUserCreatedSection:(Section *)section;
-(void)removeWord:(Word *)theWord fromUserCreatedSection:(Section *)theSection;
-(Word *)addUserCreatedWordWithLanguage1:(NSString *)language1 andLanguage2:(NSString *)language2 andlanguage2supplemental:(NSString *)language2supplemental andExampleSentences:(NSString *)exampleSentences andImage:(UIImage *)image createOnly:(BOOL)createOnly;
-(NSArray *)retrieveAllUserCreatedWords;
-(void)removeWordFromDefaultWordBank:(Word *)theWord;
-(void)removeUserCreatedWord:(Word *)word;
-(void)save;
-(void)saveWithSaveType:(NSString *)saveType;

//old methods
-(AnswerTally *)updateOrCreateAnswerTallyByWord:(SQLWord *)theWord wasCorrect:(BOOL)correct;
-(AnswerTally *)getAnswerTallyByWord:(SQLWord *)theWord;
-(NSArray *)retrieveAllAnswerTallies;
-(void)deleteAllTallies;

+(ManagedObjectsDao *)getInstance;
@end
