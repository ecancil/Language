//
//  Section.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * specialIdentifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSMutableArray *wordIDs;

@end
