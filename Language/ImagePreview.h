//
//  ImagePreview.h
//  Language
//
//  Created by Eric Cancil on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface ImagePreview : BaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
-(id)initWithImage:(UIImage *)image;
@end
