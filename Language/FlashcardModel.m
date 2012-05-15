//
//  FlashcardModel.m
//  Language
//
//  Created by Eric Cancil on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlashcardModel.h"
#import "AnswerTally.h"
#import "Word.h"
#import "SaveTypes.h"
#import "NotificationConstants.h"
#import "NSObject+NSObject_PerformSelectorOnMainThreadMultipleArgs_m.h"
#import "StyledTableCell.h"
@interface FlashcardModel ()

-(void)updateTallies;
-(void)updateTallyDictionary;
-(void)updateCell:(UITableViewCell *)theCell withValue:(NSNumber *)value;

@end

@implementation FlashcardModel
@synthesize maDao;
@synthesize  tallies;
@synthesize tallyDictionary;

static FlashcardModel *sharedInstance = nil;

+(FlashcardModel *)getInstance{
    if(sharedInstance == nil){
        sharedInstance = [[super alloc] init];
        sharedInstance.maDao = [ManagedObjectsDao getInstance];
        [sharedInstance updateTallies];
        //[[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(onSave:) name:@"Saved" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(onSave:) name:WORDBANK_SAVED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(onSave:) name:WORD_TALLY_SAVED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(onSave:) name:USER_SECTION_SAVED object:nil];
    }
    return sharedInstance;
}

-(BOOL)knowsWord: (SQLWord *)theWord{
    NSString *key = [NSString stringWithFormat:@"%@", theWord.uniqueID];
    return [tallyDictionary objectForKey:key] != nil;
}

- (void) onSave:(NSNotification *)notification
{
    [self updateTallies];
}

-(void)updateTallies{
    self.tallies = [maDao retrieveAllAnswerTallies];
    [self updateTallyDictionary];
}

-(void)updateTallyDictionary{
    self.tallyDictionary = [[NSMutableDictionary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i;
        for (i = 0; i < self.tallies.count; i ++) {
            AnswerTally *tally = (AnswerTally *)[self.tallies objectAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"%@", tally.associatedWordID];
           // NSLog(@"Adding %@", key);
            [self.tallyDictionary setValue:tally forKey:key];
        }
       // NSLog(@"for loop done");
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_REFRESH_BASE_LABELS object:self];
    
}

-(void)getPercentCorrectFromArrayOfWords:(NSArray *)arrayOfWords withCell:(UITableViewCell *)target{
    if(!arrayOfWords || arrayOfWords.count == 0){
        [self updateCell:target withValue:[NSNumber numberWithFloat:0]];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    int i;
    int totalFound = 0;
    double numberCorrect = 0;
    for (i = 0; i < arrayOfWords.count; i ++) {
        SQLWord *word = [arrayOfWords objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%@", word.uniqueID];
        //NSLog(@"looking up %@", key);
        AnswerTally *tally = (AnswerTally *)[self.tallyDictionary objectForKey:key];
        if(tally){
            if([tally.correctlyAnswered doubleValue] > [tally.incorrectlyAnswered doubleValue]){
               // NSLog(@"Found RIGHT %@ %@ %@", key, tally.correctlyAnswered, tally.incorrectlyAnswered);
                //NSLog(@"Youre Right");
                numberCorrect = numberCorrect + 1;
            }
            totalFound ++;
           // NSLog(@"Tally is not null - %d, %d", totalFound, self.tallyDictionary.allKeys.count);
            if(totalFound == self.tallyDictionary.allKeys.count){
                //NSLog(@"All are found, lets break");
                break;
            }
        }
    }
    double percent;
    if(numberCorrect > 0 && arrayOfWords.count > 0){
        percent = ceil((numberCorrect / arrayOfWords.count) * 100);
        //NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!%f %f %d", round((numberCorrect / arrayOfWords.count) * 100), numberCorrect, arrayOfWords.count);
    }   
        if(percent && arrayOfWords.count > 0){
            [self performSelectorOnMainThread:@selector(updateCell:withValue:) waitUntilDone:NO withObjects:target, [NSNumber numberWithDouble:percent], nil];

        }
    });
}

-(void)updateCell:(StyledTableCell *)theCell withValue:(NSNumber *)value{
    //theCell.textLabel.text = [theCell.textLabel.text stringByAppendingString:[NSString stringWithFormat:@" - %d%%", (int)value.doubleValue]];

    [theCell setProgressPercent:[value floatValue] / 100];
    //NSLog(@" - %d%%", (int)value.doubleValue);
    //theCell.textLabel.text = @"$$#@!$#@!$#@!$#@!";
    [theCell.textLabel setNeedsDisplay];
    [theCell setNeedsDisplay];
    [theCell setNeedsLayout];
}

@end
