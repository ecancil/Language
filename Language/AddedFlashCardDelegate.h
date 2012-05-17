//
//  AddedFlashCardDelegate.h
//  Language
//
//  Created by Eric Cancil on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashCard.h"
@class FlashCard;
@protocol AddedFlashCardDelegate <NSObject>
@optional
-(void)didFinishFlashcardSessionWithFlashcard:(FlashCard *)flashcard;
@end
