//
//  NSObject+NSString_HTML_Utilities.m
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+NSString_HTML_Utilities.h"

@implementation NSString (NSString_HTML_Utilities)

-(NSString *)htmlFromMarkup{
    NSRange r;
    NSString *theCopy = [self copy];
    //strip out html
    while ((r = [theCopy rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        theCopy = [theCopy stringByReplacingCharactersInRange:r withString:@""];
    
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[b]" withString:@"<b>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[/b]" withString:@"</b>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[br]" withString:@"<br/>"];
    
    //font colors
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[red]" withString:@"<font color='red'>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[blue]" withString:@"<font color='blue'>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[green]" withString:@"<font color='green'>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[yellow]" withString:@"<font color='yellow'>"];

    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[/color]" withString:@"</font>"];
    
    //hr
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[line]" withString:@"<hr>"];
    
    //underline
    
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[ul]" withString:@"<u>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"[/ul]" withString:@"</u>"];
    
    
    return theCopy;
}

-(NSString *)markupFromHtml{
    NSRange r;
    NSString *theCopy = [self copy];
    //strip out html
    
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<b>" withString:@"[b]<b>"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"</b>" withString:@"[/b]"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<br>" withString:@"[br/]"];
    
    //font colors
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<font color='red'" withString:@"[red]"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<font color='blue'>" withString:@"[blue]"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<font color='green'>" withString:@"[green]"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<font color='yellow'>" withString:@"[yellow]"];
    
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"</font>" withString:@"[/color]"];
    
    //hr
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<hr>" withString:@"[line]"];
    
    //underline
    
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"<u>" withString:@"[ul]"];
    theCopy = [theCopy stringByReplacingOccurrencesOfString:@"</u>" withString:@"[/ul]"];
    
    while ((r = [theCopy rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        theCopy = [theCopy stringByReplacingCharactersInRange:r withString:@""];
    
    
    return theCopy;
}

-(NSInteger)returnNumberOfInstancesOfSubstring:(NSString *)substring{
    NSString *theCopy = [self copy];
    NSUInteger count = 0, length = [theCopy length];
    NSRange range = NSMakeRange(0, length); 
    while(range.location != NSNotFound)
    {
        range = [theCopy rangeOfString: substring options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    return count;
}

@end
