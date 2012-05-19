//
//  FlickrPhotoSource.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface FlickrPhotoSource : TTURLRequestModel <TTPhotoSource>

@property (nonatomic, retain) NSArray *photos;
- (id) initWithTitle:(NSString *)theTitle photos:(NSArray *)thePhotos;
@end
