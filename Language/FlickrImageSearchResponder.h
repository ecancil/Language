//
//  FlickrImageSearchResponder.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlickrImageSearchResponder <NSObject>
-(void)imagesDidLoad:(NSArray *)images;
@end