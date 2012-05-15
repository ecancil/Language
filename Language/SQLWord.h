//
//  SQLWord.h
//  Demo
//
//  Created by Eric Cancil on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLWord : NSObject{
NSString *language1;
NSString *language2;
NSString *section;
NSString *language2supplemental;
    int index;
    NSString *examples;
    NSNumber *uniqueID;
}
@property(nonatomic, retain) NSString *language1;
@property(nonatomic, retain) NSString *language2;
@property(nonatomic, retain) NSString *section;
@property(nonatomic, retain) NSString *language2supplemental;
@property(nonatomic, retain) NSString *examples;
//@property (nonatomic, assign) int index;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSNumber *uniqueID;

@property(nonatomic, retain) NSString *specialIdentifier;
@property(nonatomic, retain) NSString *alternateSpecialIdentifier;

@end
