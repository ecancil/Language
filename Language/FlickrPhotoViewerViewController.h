//
//  FlickrPhotoViewerViewController.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"
#import "BaseViewController.h"

@interface FlickrPhotoViewerViewController : BaseViewController <NSURLConnectionDataDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
-(id)initWithFlickrPhoto:(FlickrPhoto *)flickrPhoto;
@end
