//
//  FlashCardDisplayPane.h
//  Language
//
//  Created by Eric Cancil on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardBase.h"

@interface FlashCardDisplayPane : UIViewController
@property (strong, nonatomic) IBOutlet CardBase *front;
@property (strong, nonatomic) IBOutlet CardBase *back;
@property (strong, nonatomic) CardBase *currentlyEditingCard;
@property (strong, nonatomic) NSString *currentlyEditingPreference;
- (void)onDisplayChange:(id)sender;
-(void)showBackPickerWithTruncatedList;

@end
