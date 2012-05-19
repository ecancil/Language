//
//  FlickrPhotoSource.m
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoSource.h"
#import "FlickrPhoto.h"


@implementation FlickrPhotoSource
@synthesize title;
@synthesize numberOfPhotos;
@synthesize maxPhotoIndex;
@synthesize photos;



- (id) initWithTitle:(NSString *)theTitle photos:(NSArray *)thePhotos {
    if ((self = [super init])) {
        self.title = theTitle;
        self.photos = thePhotos;
        for(int i = 0; i < thePhotos.count; ++i) {
            FlickrPhoto *photo = [thePhotos objectAtIndex:i];
            photo.photoSource = self;
            photo.index = i;
        }        
    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    self.photos = nil;    
}

#pragma mark TTModel

- (BOOL)isLoading { 
    return FALSE;
}

- (BOOL)isLoaded {
    return TRUE;
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
    return photos.count;
}

- (NSInteger)maxPhotoIndex {
    return photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < photos.count) {
        return [photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}

@end
