//
//  FlickrResults.h
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrImageSearchResponder.h"
#import "AddWordModel.h"
#import "BaseViewController.h"

@interface FlickrResults : BaseViewController <FlickrImageSearchResponder, NSURLConnectionDataDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
-(id)initWithModel:(AddWordModel *)theModel;
@end
