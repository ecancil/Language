//
//  FlashcardModel.h
//  Language
//
//  Created by Eric Cancil on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectsDao.h"

@interface FlashcardModel : NSObject{
    NSArray *tallies; 
}

@property(nonatomic, retain) ManagedObjectsDao *maDao;
@property(nonatomic, retain) NSArray *tallies;
@property(nonatomic, retain) NSMutableDictionary *tallyDictionary;
+(FlashcardModel *)getInstance;
-(void)getPercentCorrectFromArrayOfWords:(NSArray *)arrayOfWords withCell:(UITableViewCell *)target;
-(BOOL)knowsWord: (Word *)theWord;
@end
