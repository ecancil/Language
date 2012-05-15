//
//  Word.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * examples;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * language1;
@property (nonatomic, retain) NSString * language2;
@property (nonatomic, retain) NSString * language2supplemental;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * specialIdentifier;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSString * alternateSpecialIdentifier;

@end
