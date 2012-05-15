//
//  SingleFlashcardSession.h
//  Language
//
//  Created by Eric Cancil on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleFlashcardSession : NSObject{
    
    
}

@property(nonatomic, retain) NSArray *sessionWords;
@property(nonatomic, retain) NSMutableArray *wrongItems;
@property(nonatomic, assign) int amountCorrect;
@property(nonatomic, assign) BOOL isSupplementaryStudy;
@property(nonatomic, retain) NSArray *supplementarySessionWords;
@property(nonatomic, assign) int cardIndex;


-(void)resetWithSessionWords:(NSArray *)theWords;

-(void)restudy;
-(void)studyIncorrect;
@end
