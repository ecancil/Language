//
//  RomanjiToHiragana.h
//  Demo
//
//  Created by Eric Cancil on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RomanjiToHiragana : NSObject{
    NSMutableDictionary *symbolDict;
}
@property(nonatomic, retain)NSMutableDictionary *symbolDict;
- (NSString *)romanjiToKana:(NSString *)romanji;
@end
