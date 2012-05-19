//
//  FlickrResults.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrImageSearchResponder.h"

@interface FlickrResults : UIViewController <FlickrImageSearchResponder>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
