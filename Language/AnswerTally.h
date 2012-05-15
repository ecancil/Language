//
//  AnswerTally.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AnswerTally : NSManagedObject

@property (nonatomic, retain) NSNumber * correctlyAnswered;
@property (nonatomic, retain) NSNumber * incorrectlyAnswered;
@property (nonatomic, retain) NSNumber * associatedWordID;

@end
