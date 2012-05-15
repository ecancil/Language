//
//  MenuValuesModel.m
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DaoInteractor.h"


@interface DaoInteractor ()
@property (nonatomic, retain) NSMutableArray *menuUpdateResponders;

//startup checks
@property(nonatomic, assign) BOOL initialNonUserDefaultWords;
@property(nonatomic, assign) BOOL initialUserCreatedWords;
@property(nonatomic, assign) BOOL initialDefaultSections;
@property(nonatomic, assign) BOOL intialWordBankSection;
@property(nonatomic, assign) BOOL initialUserCreatedWordSection;
@property(nonatomic, assign) BOOL initialAllUserCreatedSections;
@property(nonatomic, retain) ManagedObjectsDao *moDao;

-(void)sendUpdateForMenuUpdateType:(MenuUpdateType)menuUpdateType;
-(void)checkInitialLoadComplete;
-(void)removeWordFromUserCreatedWordFromArray:(Word *)theWord;
-(void)removeSectionFromUserCreatedSectionArray:(Section *)theSection;
@end

@implementation DaoInteractor
//menu values
@synthesize allDefaultWords;
@synthesize allUserCreatedWords;
@synthesize allDefaultSections;
@synthesize allUserCreatedSections;

//sections
@synthesize defaultWordBank;
@synthesize defaultUserCreatedWordsSection;

//startup checks
@synthesize initialNonUserDefaultWords;
@synthesize initialUserCreatedWords;
@synthesize initialDefaultSections;
@synthesize intialWordBankSection;
@synthesize initialUserCreatedWordSection;
@synthesize initialAllUserCreatedSections;

//done
@synthesize completelyInitialized;

//responders
@synthesize  menuUpdateResponders;

//daos
@synthesize moDao;




static DaoInteractor *sharedInstance = nil;

+(DaoInteractor *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
        sharedInstance.allUserCreatedSections = [[NSMutableArray alloc] init];
    }
    return sharedInstance;
}

-(void)doInitialMenuRetrieval{  
    WordsDAOImpl *wordsDao = [[WordsDAOImpl alloc] initWithDatabasePath:@"words.sqlite"];
    moDao = [ManagedObjectsDao getInstance];
    NSArray *allNonUserDefaultWords = [wordsDao retrieveAllContentsFromTable:@"words"];
    NSArray *allUserCreatedWordsLocal = [moDao retrieveAllUserCreatedWords];
    
    //fetch and index default words
    [WordCache addBulkWords:allNonUserDefaultWords withCompletion:^{
        self.allDefaultWords = allNonUserDefaultWords;
        self.initialNonUserDefaultWords = YES;
        [self sendUpdateForMenuUpdateType:DefaultWordsUpdate];
        [self checkInitialLoadComplete];
    }];
    
    //fetch and index user created words
    [WordCache addBulkWords:allUserCreatedWordsLocal withCompletion:^{
        self.allUserCreatedWords = allUserCreatedWordsLocal.mutableCopy;
        self.initialUserCreatedWords = YES;
        [self sendUpdateForMenuUpdateType:UserCreatedWordsUpdate];
        [self checkInitialLoadComplete];        
    }];
    
    //fetch the sections
    self.allDefaultSections = [wordsDao retrieveDistinctItemsByColumnName:@"Section" FromTable:@"words"];
    initialDefaultSections = YES;
    [self sendUpdateForMenuUpdateType:AllDefaultSectionsUpdate];
    [self checkInitialLoadComplete];    
    
    //fetch wordbank and usercreated word sections
    self.defaultWordBank = [moDao retrieveDefaultWordBank];
    //giving the dao a reference here so that the wordbank doesnt always have to be passed down
    self.moDao.defaultWordBank = self.defaultWordBank;
    self.defaultUserCreatedWordsSection = [moDao retrieveUserWordsSection];
    self.initialUserCreatedWordSection = self.intialWordBankSection = YES;
    [self sendUpdateForMenuUpdateType:DefaultWordBankUpdate];
    [self sendUpdateForMenuUpdateType:DefaultUserSectionUpdate];
    [self checkInitialLoadComplete];
    
    //fetch all user created sections
    NSArray *temp =  [self.moDao retrieveAllUserCreatedSections];
    if(temp.count != 0){
        self.allUserCreatedSections = temp.mutableCopy;
    }
    self.initialAllUserCreatedSections = YES;
    [self sendUpdateForMenuUpdateType:UserCreatedSectionsUpdate];
    [self checkInitialLoadComplete];
}



-(void)checkInitialLoadComplete{
    if (self.initialNonUserDefaultWords && self.initialUserCreatedWords && self.initialDefaultSections && self.initialUserCreatedWordSection && self.intialWordBankSection && self.initialAllUserCreatedSections) {
        self.completelyInitialized = YES;
        [self sendUpdateForMenuUpdateType:AllInitialLoaded];
    }
}


#pragma -
#pragma UPDATES

-(void)addTarget:(id)target andSelector:(SEL)selector forMenuUpdateType:(MenuUpdateType)menuUpdateType{
    if(!self.menuUpdateResponders)self.menuUpdateResponders = [[NSMutableArray alloc] init];
    MenuUpdateResponder responder = {.target = target, .selector = selector, .menuUpdateType = menuUpdateType};
    NSValue *valueWithStruct = [NSValue valueWithBytes:&responder objCType:@encode(MenuUpdateResponder)];
    [menuUpdateResponders addObject:valueWithStruct];
}

-(void)sendUpdateForMenuUpdateType:(MenuUpdateType)menuUpdateType{
    int i = 0;
    int count = menuUpdateResponders.count;
    for (i; i < count; i ++) {
        NSValue *foundValue = [menuUpdateResponders objectAtIndex:i];
        MenuUpdateResponder foundResponder;
        [foundValue getValue:&foundResponder];
        if(foundResponder.menuUpdateType == menuUpdateType){
            [foundResponder.target performSelector:foundResponder.selector];
        }
    }
}

#pragma -
#pragma CONVENIENCE METHODS

-(SQLSection *)getDefaultSectionByIndex:(int)index{
    WordsDAOImpl *wordsDao = [[WordsDAOImpl alloc] initWithDatabasePath:@"words.sqlite"];
    SQLSection *toReturn;
    if(self.allDefaultSections){
        toReturn = (SQLSection *)[self.allDefaultSections objectAtIndex:index];
        if(toReturn.words == nil || toReturn.words.count == 0){
            toReturn.words = [wordsDao retrieveAllContentsBySectionName:toReturn.title FromTable:@"words"];
        }
    }
    return toReturn;
}

-(Section *)getUserCreatedSectionByIndex:(int)index{
    Section *section = (Section *)[self.allUserCreatedSections objectAtIndex:index];
    return section;
}

-(BOOL)wordExistsInWordBank:(Word *)word{
    int i = 0;
    NSArray *wordBankWordIDs = self.defaultWordBank.wordIDs;
    int count = wordBankWordIDs.count;
    for (i; i < count; i ++) {
        NSNumber *foundNumber = [self.defaultWordBank.wordIDs objectAtIndex:i];
        NSLog(@"%fl, %fl", foundNumber.doubleValue, word.uniqueID.doubleValue);
        if(foundNumber.doubleValue == word.uniqueID.doubleValue){
            return YES;
        }
    }
    return NO;
}

-(BOOL)word:(Word *)word ExistsInUserCreatedSection:(Section *)section{
    int i = 0;
    NSArray *sectionIDs = section.wordIDs;
    int count = sectionIDs.count;
    for (i; i < count; i ++) {
        NSNumber *foundNumber = [sectionIDs objectAtIndex:i];
        NSLog(@"%fl, %fl", foundNumber.doubleValue, word.uniqueID.doubleValue);
        if(foundNumber.doubleValue == word.uniqueID.doubleValue){
            return YES;
        }
    }
    return NO;
}

#pragma -
#pragma local convenience methods

-(void)removeWordFromUserCreatedWordFromArray:(Word *)theWord{
    int i = 0;
    int count = self.allUserCreatedWords.count;
    for (i; i < count; i ++) {
        Word *foundWord = [self.allUserCreatedWords objectAtIndex:i];
        if(foundWord.uniqueID.doubleValue == theWord.uniqueID.doubleValue){
            [self.allUserCreatedWords removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)removeSectionFromUserCreatedSectionArray:(Section *)theSection{
    int i = 0;
    int count = self.allUserCreatedSections.count;
    for (i; i < count; i ++) {
        Section *foundSection = [self.allUserCreatedSections objectAtIndex:i];
        if(foundSection.uniqueID.doubleValue == theSection.uniqueID.doubleValue){
            [self.allUserCreatedSections removeObjectAtIndex:i];
            break;
        }
    }
}


#pragma -
#pragma proxy to interact with dao
//this is to keep things consistent - all viewControllers derived from BaseViewController will have access to this
-(Word *)addUserCreatedWordWithLanguage1:(NSString *)language1 andLanguage2:(NSString *)language2 andlanguage2supplemental:(NSString *)language2supplemental andExampleSentences:(NSString *)exampleSentences andImage:(UIImage *)image createOnly:(BOOL)createOnly{
    Word *word = [moDao addUserCreatedWordWithLanguage1:language1 andLanguage2:language2 andlanguage2supplemental:language2supplemental andExampleSentences:exampleSentences andImage:image createOnly:createOnly];
    self.allUserCreatedWords = [self.allUserCreatedWords arrayByAddingObject:word].mutableCopy;
    [WordCache addWordToCacheByKey:word.uniqueID forValue:word];
    [self sendUpdateForMenuUpdateType:UserCreatedWordsUpdate];
    return word;
}

-(void)removeUserCreatedWord:(Word *)word{
    [self removeWordFromUserCreatedWordFromArray:word];
    if ([self wordExistsInWordBank:word]) {
        [self removeWordFromDefaultWordBank:word];
    }
    [moDao removeUserCreatedWord:word];
    [self sendUpdateForMenuUpdateType:UserCreatedWordsUpdate];
}

-(void)addWordToDefaultWordBank:(Word *)word{
    [moDao addWordToDefaultWordBank:word];
    [self sendUpdateForMenuUpdateType:DefaultWordBankUpdate];
}

-(void)removeWordFromDefaultWordBank:(Word *)theWord{
    [moDao removeWordFromDefaultWordBank:theWord];
    [self sendUpdateForMenuUpdateType:DefaultWordBankUpdate];
}

-(void)saveWithSaveType:(NSString *)saveType{
    [moDao saveWithSaveType:saveType];
}

-(Section *)addNewSectionByTitle:(NSString *)title{
    Section *section = [moDao addNewSectionByTitle:title];
    if(self.allUserCreatedSections.count == 1 && [[self.allUserCreatedSections objectAtIndex:0] isKindOfClass:[NSString class]]){
        self.allUserCreatedSections = [[NSMutableArray alloc] init];
    }
    [self.allUserCreatedSections addObject:section];
    [self sendUpdateForMenuUpdateType:UserCreatedSectionsUpdate];
    return section;
}

-(void)eraseUserCreatedSection:(Section *)section{
    [self removeSectionFromUserCreatedSectionArray:section];
    [self.moDao eraseUserCreatedSection:section];
    //were not sending an alert here because it disrupts the remove animation
    //[self sendUpdateForMenuUpdateType:UserCreatedSectionsUpdate];
}

-(void)addWord:(Word *)word ToSection:(Section *)section{
    if([self word:word ExistsInUserCreatedSection:section] == NO){
        [self.moDao addWord:word ToSection:section];
        [self sendUpdateForMenuUpdateType:UserCreatedSectionsUpdate];
    }
}

-(void)removeWord:(Word *)theWord fromUserCreatedSection:(Section *)theSection{
    [self.moDao removeWord:theWord fromUserCreatedSection:theSection];
    [self sendUpdateForMenuUpdateType:UserCreatedSectionsUpdate];
}

-(Section *)addNewSectionByTitle:(NSString *)title withWords:(NSArray *)words{
    Section *section = [moDao addNewSectionByTitle:title withWords:words];
    if(self.allUserCreatedSections.count == 1 && [[self.allUserCreatedSections objectAtIndex:0] isKindOfClass:[NSString class]]){
        self.allUserCreatedSections = [[NSMutableArray alloc] init];
    }
    [self.allUserCreatedSections addObject:section];
    [self sendUpdateForMenuUpdateType:UserCreatedSectionsUpdate];
    return section;
}

-(AnswerTally *)updateOrCreateAnswerTallyByWord:(Word *)theWord wasCorrect:(BOOL)correct{
    [moDao updateOrCreateAnswerTallyByWord:theWord wasCorrect:correct];
}


@end

