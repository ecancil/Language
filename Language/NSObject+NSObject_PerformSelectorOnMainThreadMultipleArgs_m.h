//
//  NSObject+NSObject_PerformSelectorOnMainThreadMultipleArgs_m.h
//  Language
//
//  Created by Eric Cancil on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_PerformSelectorOnMainThreadMultipleArgs_m)
-(void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ...;
@end
