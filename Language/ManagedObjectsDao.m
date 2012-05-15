//
//  ManagedObjectsDao.m
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectsDao.h"
#import "Section.h"
#import "Word.h"
#import "SaveTypes.h"
#import "SpecialIdentifiers.h"
#import "LocalizationStringConstants.h"

@interface ManagedObjectsDao ()
-(void)checkForAndAddWordBank;
-(void)checkForAndAddUserWordsSection;

@property(nonatomic, assign) BOOL temporarilyPreventSaving;
@property(nonatomic, assign) BOOL sendAllSaveTypes;
@property(nonatomic, assign) int totallyActuallyLooped;
-(NSMutableArray *)removeObjectFromArrayOfNumbers:(NSMutableArray *)arrayOfNumbers byID:(NSNumber *)ID;
@end
    

@implementation ManagedObjectsDao
@synthesize context;
@synthesize document;
@synthesize defaultWordBank;
@synthesize allWords;
@synthesize temporarilyPreventSaving;
@synthesize sendAllSaveTypes;
@synthesize totallyActuallyLooped;


static ManagedObjectsDao *sharedInstance = nil;

+(ManagedObjectsDao *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
       
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"LanguageModel"];

        UIManagedDocument *d = [[UIManagedDocument alloc] initWithFileURL:url];
        
        sharedInstance.document = d;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
            [d openWithCompletionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"Did open document");
                    sharedInstance.context = [d managedObjectContext];
                    [sharedInstance checkForAndAddWordBank];
                    [sharedInstance checkForAndAddUserWordsSection];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startup_complete" object:self];
                }else{
                    NSLog(@"Couldn't open document");
                }
            }];
        }else{
            [d saveToURL:url forSaveOperation:UIDocumentSaveForCreating 
            completionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"Did create document");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startup_complete" object:self];
                    sharedInstance.context = [d managedObjectContext];
                    [sharedInstance checkForAndAddWordBank]; 
                    [sharedInstance checkForAndAddUserWordsSection];
                }else{
                    NSLog(@"Couldn't create document");
                }
            }];
        }
        
//        sharedInstance.context = [appDelegate manag
    }
    return sharedInstance;
}  

-(NSMutableArray *)removeObjectFromArrayOfNumbers:(NSMutableArray *)arrayOfNumbers byID:(NSNumber *)ID{
    NSMutableArray *copy = arrayOfNumbers.mutableCopy;
    NSLog(@"copy length %d", copy.count);
    int i = 0;
    int count = copy.count;
    for (i; i < count; i ++) {
        NSNumber *foundNumber = [copy objectAtIndex:i];
        if(foundNumber.doubleValue == ID.doubleValue){
            [copy removeObjectAtIndex:i];
            NSLog(@"copy length %d", copy.count);
            return copy;
        }
    }
    return nil;
}

-(void)checkForAndAddWordBank{
    if(![self retrieveDefaultWordBank]){
        Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
        section.uniqueID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        NSString *title = NSLocalizedString(WORD_BANK_TITLE, nil);
        section.specialIdentifier = WORD_BANK;
        section.title = title;
        section.uniqueID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [self saveWithSaveType:WORDBANK_SAVED];
    }
}


-(Section *)retrieveDefaultWordBank{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"specialIdentifier" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specialIdentifier contains %@", WORD_BANK];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
    request.fetchBatchSize = 1;
    request.fetchLimit = 1;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.predicate = predicate;
    NSArray *sections = [context executeFetchRequest:request error:&error];
    Section *section;
    if(sections.count > 0){
        section = (Section *)[sections objectAtIndex:0];
    }
    return section;
}

-(void)checkForAndAddUserWordsSection{
    if(![self retrieveUserWordsSection]){
        Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
        section.uniqueID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        NSString *title = NSLocalizedString(USER_CREATED_WORDS_SECTION_TITLE, nil);
        section.specialIdentifier = ALL_USER_CREATED_WORDS;
        section.title = title;
        section.uniqueID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [self saveWithSaveType:WORD_SAVED];
    }
}

-(Section *)retrieveUserWordsSection{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"specialIdentifier" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specialIdentifier contains %@", ALL_USER_CREATED_WORDS];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
    request.fetchBatchSize = 1;
    request.fetchLimit = 1;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.predicate = predicate;
    NSArray *sections = [context executeFetchRequest:request error:&error];
    Section *section;
    if(sections.count > 0){
        section = (Section *)[sections objectAtIndex:0];
    }
    return section;
}

-(void)save{
    if(temporarilyPreventSaving)return;
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting 
           completionHandler:^(BOOL success) {
               if(success){
                   NSLog(@"Document was saved");
                  // [[NSNotificationCenter defaultCenter] postNotificationName:@"Saved" object:self];
               }else{
                   NSLog(@"Document could not be saved");
               }
           }];
}

-(void)saveWithSaveType:(NSString *)saveType{
    if(temporarilyPreventSaving)return;
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting 
           completionHandler:^(BOOL success) {
               if(success){
                   NSLog(@"Document was saved");
                   [[NSNotificationCenter defaultCenter] postNotificationName:saveType object:self];
                   if(sendAllSaveTypes){
                       [[NSNotificationCenter defaultCenter] postNotificationName:WORD_TALLY_SAVED object:self];
                       //[[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_ALL object:self];
                       sendAllSaveTypes = NO;
                   }
               }else{
                   NSLog(@"Document could not be saved");
               }
           }];
}

-(void)addWordToDefaultWordBank:(Word *)word{
    NSMutableArray *wordIDs = self.defaultWordBank.wordIDs;
    if(!wordIDs){
        self.defaultWordBank.wordIDs = [[NSMutableArray alloc] init];
    }
    defaultWordBank.wordIDs = [defaultWordBank.wordIDs arrayByAddingObject:word.uniqueID].mutableCopy;
    [self saveWithSaveType:WORDBANK_SAVED];
}

-(void)removeWordFromDefaultWordBank:(Word *)theWord{
    self.defaultWordBank.wordIDs = [NSMutableArray arrayWithArray:[self removeObjectFromArrayOfNumbers:defaultWordBank.wordIDs byID:theWord.uniqueID].copy];
    [self saveWithSaveType:WORDBANK_SAVED];
}

-(Section *)addNewSectionByTitle:(NSString *)title{
    Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
    section.uniqueID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    section.title = title;
    section.specialIdentifier = USER_CREATED;
    
    [self saveWithSaveType:USER_SECTION_SAVED];
    return section;
}

-(Section *)addNewSectionByTitle:(NSString *)title withWords:(NSArray *)words{
    Section *section = [self addNewSectionByTitle:title];
    int i = 0;
    int count = words.count;
    for (i; i < count; i ++) {
        Word *foundWord = (Word *)[words objectAtIndex:i];
        [self addWord:foundWord ToSection:section];
    }
    return section;
}

-(void)addWord:(Word *)word ToSection:(Section *)section{
    NSMutableArray *wordIDs = section.wordIDs;
    if(!wordIDs){
        section.wordIDs = [[NSMutableArray alloc] init];
    }
    section.wordIDs = [section.wordIDs arrayByAddingObject:word.uniqueID].mutableCopy;
    [self saveWithSaveType:USER_SECTION_SAVED];
}

-(NSArray *)retrieveAllUserCreatedSections{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specialIdentifier contains %@", USER_CREATED];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.predicate = predicate;
    
    NSArray *sections = [context executeFetchRequest:request error:&error];
    
    return sections;
}

-(void)eraseUserCreatedSection:(Section *)section{
    [context deleteObject:section];
    
    [self saveWithSaveType:USER_SECTION_SAVED];
}

-(void)removeWord:(Word *)theWord fromUserCreatedSection:(Section *)theSection{
    theSection.wordIDs = [NSMutableArray arrayWithArray:[self removeObjectFromArrayOfNumbers:theSection.wordIDs byID:theWord.uniqueID].copy];
    [self saveWithSaveType:USER_SECTION_SAVED];
}

-(Word *)addUserCreatedWordWithLanguage1:(NSString *)language1 andLanguage2:(NSString *)language2 andlanguage2supplemental:(NSString *)language2supplemental andExampleSentences:(NSString *)exampleSentences andImage:(UIImage *)image createOnly:(BOOL)createOnly{
         Word *theWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
         theWord.language1 = language1;
         theWord.language2 = language2;
         theWord.language2supplemental = language2supplemental;
         theWord.examples = exampleSentences;
         theWord.image = image;
         theWord.specialIdentifier = USER_CREATED;
         theWord.uniqueID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    
    if(createOnly){
        [[NSNotificationCenter defaultCenter] postNotificationName:GOOGLE_WORD_SAVED object:self];
        //[self saveWithSaveType:GOOGLE_WORD_SAVED];
    }else{
        [self saveWithSaveType:WORD_SAVED];      
    }
         return theWord;

}

-(NSArray *)retrieveAllUserCreatedWords{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uniqueID" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specialIdentifier contains %@", USER_CREATED];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.predicate = predicate;
    
    NSArray *words = [context executeFetchRequest:request error:&error];
    
    return words;
}

-(void)removeUserCreatedWord:(Word *)word{
    word.specialIdentifier = nil;
    [self.context deleteObject:word];
    [self saveWithSaveType:WORD_SAVED];
}

-(AnswerTally *)updateOrCreateAnswerTallyByWord:(Word *)theWord wasCorrect:(BOOL)correct{
    AnswerTally *tally = [self getAnswerTallyByWord:theWord];
    if(!tally){
         tally = [NSEntityDescription insertNewObjectForEntityForName:@"AnswerTally" inManagedObjectContext:context];
        tally.associatedWordID = theWord.uniqueID;
    }
    NSInteger amountCorrect = tally.correctlyAnswered.intValue;
    NSInteger amountIncorrect = tally.incorrectlyAnswered.intValue;
    if(correct){
        amountCorrect ++;
        tally.correctlyAnswered = [NSNumber numberWithInt:amountCorrect];
    }else{
        amountIncorrect ++;
        tally.incorrectlyAnswered = [NSNumber numberWithInt:amountIncorrect];
    }
    
    [self saveWithSaveType:WORD_TALLY_SAVED];
    NSNumber *uid = tally.associatedWordID;

    return tally;

}



-(AnswerTally *)getAnswerTallyByWord:(Word *)theWord{
    //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uniqueID" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"associatedWordID = %@", theWord.uniqueID];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AnswerTally"];
    request.predicate = predicate;
    request.fetchBatchSize = 1;
    request.fetchLimit = 1;
    
    NSArray *tallies = [context executeFetchRequest:request error:&error];
    
    AnswerTally *tally;
    
    if(tallies.count > 0){
        tally = (AnswerTally *)[tallies objectAtIndex:0];
    }
    
    return tally; 
}

-(NSArray *)retrieveAllAnswerTallies{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"associatedWord.language1 = %@ and associatedWord.language2 = %@", theWord.language1, theWord.language2];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AnswerTally"];
    //request.predicate = predicate;
    
    NSArray *tallies = [context executeFetchRequest:request error:&error];
    
    return tallies; 
 
}

-(void)deleteAllTallies{
    NSFetchRequest *allTallies = [[NSFetchRequest alloc] init];
    [allTallies setEntity:[NSEntityDescription entityForName:@"AnswerTally" inManagedObjectContext:self.context]];
    [allTallies setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray *tallies = [self.context executeFetchRequest:allTallies error:&error];

    //error handling goes here
    for (NSManagedObject *tally in tallies) {
        [self.context deleteObject:tally];
    }
   
    [self saveWithSaveType:WORD_TALLY_SAVED];
}





@end
