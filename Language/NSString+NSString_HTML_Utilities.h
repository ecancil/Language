//
//  NSObject+NSString_HTML_Utilities.h
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_HTML_Utilities)
-(NSString *)htmlFromMarkup;
-(NSInteger)returnNumberOfInstancesOfSubstring:(NSString *)substring;
-(NSString *)markupFromHtml;
@end
