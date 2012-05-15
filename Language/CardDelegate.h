//
//  CardDelegate.h
//  Language
//
//  Created by Eric Cancil on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLWord.h"

@protocol CardDelegate <NSObject>
@optional
-(SQLWord *)wordData;
-(void)onStudyIncorrectItems;
-(void)onRestudy;
-(void)onDone;
@end
