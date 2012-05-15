//
//  SingleFlashcardSession.m
//  Language
//
//  Created by Eric Cancil on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleFlashcardSession.h"

@implementation SingleFlashcardSession
@synthesize amountCorrect;
@synthesize wrongItems;
@synthesize sessionWords;
@synthesize isSupplementaryStudy;
@synthesize cardIndex;
@synthesize supplementarySessionWords;

-(id)init{
    if([super init]){
        self.wrongItems = [[NSMutableArray alloc] init];
        isSupplementaryStudy = NO;
        self.cardIndex = -1;
    }
    return self;
}

-(void)resetWithSessionWords:(NSArray *)theWords{
    self.sessionWords = theWords;
}

-(void)restudy{
    self.cardIndex = -1;
    self.wrongItems = [[NSMutableArray alloc] init];
    self.isSupplementaryStudy = NO;
}
-(void)studyIncorrect{
    self.cardIndex = -1;
    self.supplementarySessionWords = [NSArray arrayWithArray:self.wrongItems];
    self.wrongItems = [[NSMutableArray alloc] init];
    isSupplementaryStudy = YES;
}

@end
