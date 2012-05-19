//
//  FlickrPhoto.m
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhoto.h"

@implementation FlickrPhoto
@synthesize fullSizePhoto;
@synthesize thumbnail;
@synthesize photoSource;
@synthesize size;
@synthesize index;
@synthesize caption;

-(id)init{
    if([super init]){
        self.caption = nil;
        //self.size = nil;
        self.index = NSIntegerMax;
        self.photoSource = nil;
    }
    return self;
}


- (NSString*)URLForVersion:(TTPhotoVersion)version{
    switch (version) {
        case TTPhotoVersionLarge:
            return fullSizePhoto;
            break;
        case TTPhotoVersionMedium:
            return fullSizePhoto;
            break;
        case TTPhotoVersionSmall:
            return thumbnail;
            break;
            case TTPhotoVersionThumbnail:
            return thumbnail;
            break;
        default:
            break;
    }
}
@end
