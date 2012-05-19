//
//  FlickrImageSearchDao.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrImageSearchResponder.h"

@interface FlickrImageSearchDao : NSObject <NSURLConnectionDataDelegate , NSXMLParserDelegate>
-(void)searchForImagesByString:(NSString *)searchString;
-(id)initWithResponder:(id<FlickrImageSearchResponder>)responder;
@end
