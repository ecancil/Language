//
//  FlickrPhoto.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface FlickrPhoto : NSObject <TTPhoto>

/**
 * The photo source that the photo belongs to.
 */
@property (nonatomic, assign) id<TTPhotoSource> photoSource;

/**
 * The size of the photo.
 */
@property (nonatomic) CGSize size;

/**
 * The index of the photo within its photo source.
 */
@property (nonatomic) NSInteger index;

/**
 * The caption of the photo.
 */
@property (nonatomic, copy) NSString* caption;

/**
 * Gets the URL of one of the differently sized versions of the photo.
 */
- (NSString*)URLForVersion:(TTPhotoVersion)version;
@property(nonatomic, retain) NSString *fullSizePhoto;
@property(nonatomic, retain) NSString *thumbnail;
@end
