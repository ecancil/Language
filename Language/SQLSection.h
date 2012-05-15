//
//  SQLSection.h
//  Demo
//
//  Created by Eric Cancil on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLSection : NSObject{ 
    NSString *title;
    NSArray *words;
}
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSArray *words;
@property(nonatomic, retain) NSArray *wordIDs ;
@property(nonatomic, retain) NSString *specialIdentifier;

@end
