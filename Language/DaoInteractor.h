//
//  MenuValuesModel.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordsDAOImpl.h"
#import "WordCache.h"
#import "ManagedObjectsDao.h"
#import "SQLSection.h"
#import "Section.h"
#import "Word.h"
#import "AnswerTally.h"


@interface DaoInteractor : NSObject

typedef enum{ 
    AllInitialLoaded,
    DefaultWordsUpdate,
    UserCreatedWordsUpdate,
    AllDefaultSectionsUpdate,
    DefaultWordBankUpdate,
    DefaultUserSectionUpdate,
    UserCreatedSectionsUpdate
}MenuUpdateType;

typedef struct{
    __unsafe_unretained NSObject *target;
    SEL selector;
    MenuUpdateType menuUpdateType;
}MenuUpdateResponder;


//menu Values
@property(nonatomic, retain) NSArray *allDefaultWords;
@property(nonatomic, retain) NSArray *allDefaultSections;
@property(nonatomic, retain) NSMutableArray *allUserCreatedWords;
@property(nonatomic, retain) NSMutableArray *allUserCreatedSections;

//sections
@property(nonatomic, retain) Section *defaultWordBank;
@property(nonatomic, retain) Section *defaultUserCreatedWordsSection;


//startup
@property(nonatomic, assign) BOOL completelyInitialized; 


//startup
-(void)doInitialMenuRetrieval;

//convenience
-(SQLSection *)getDefaultSectionByIndex:(int)index;
-(BOOL)wordExistsInWordBank:(Word *)word;
-(BOOL)word:(Word *)word ExistsInUserCreatedSection:(Section *)section;
-(Section *)getUserCreatedSectionByIndex:(int)index;

//messaging
-(void)addTarget:(id)target andSelector:(SEL)selector forMenuUpdateType:(MenuUpdateType)menuUpdateType;


//proxy to interact with dao
//This allows the menu objects to be updated with the same efficiency no matter where things are added across the app
-(Word *)addUserCreatedWordWithLanguage1:(NSString *)language1 andLanguage2:(NSString *)language2 andlanguage2supplemental:(NSString *)language2supplemental andExampleSentences:(NSString *)exampleSentences andImage:(UIImage *)image createOnly:(BOOL)createOnly;

-(void)addWordToDefaultWordBank:(Word *)word;

-(void)removeWordFromDefaultWordBank:(Word *)theWord;

-(void)removeUserCreatedWord:(Word *)word;

-(void)saveWithSaveType:(NSString *)saveType;

-(Section *)addNewSectionByTitle:(NSString *)title;

-(void)eraseUserCreatedSection:(Section *)section;

-(void)addWord:(Word *)word ToSection:(Section *)section;

-(void)removeWord:(Word *)theWord fromUserCreatedSection:(Section *)theSection;

-(Section *)addNewSectionByTitle:(NSString *)title withWords:(NSArray *)words;

-(AnswerTally *)updateOrCreateAnswerTallyByWord:(Word *)theWord wasCorrect:(BOOL)correct;


//class methods
+(DaoInteractor *)getInstance;

@end
