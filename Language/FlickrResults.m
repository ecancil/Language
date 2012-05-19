//
//  FlickrResults.m
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrResults.h"
#import "Three20/Three20.h"
#import "FlickrImageSearchDao.h"
#import "FlickrPhotoSource.h"

@interface FlickrResults ()
@property(nonatomic, retain) FlickrImageSearchDao *flickrDao;
@property(nonatomic, retain) FlickrPhotoSource *flickrPhotoSource;
@end

@implementation FlickrResults
@synthesize flickrDao;
@synthesize flickrPhotoSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flickrDao = [[FlickrImageSearchDao alloc] initWithResponder:self];
    [flickrDao searchForImagesByString:@"Sandwich"];
    // Do any additional setup after loading the view from its nib.
}
     
-(void)imagesDidLoad:(NSArray *)images{
    flickrPhotoSource = [[FlickrPhotoSource alloc] initWithTitle:@"" photos:images];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)thumbsViewController: (TTThumbsViewController*)controller
              didSelectPhoto: (id<TTPhoto>)photo{
    
}



- (BOOL)thumbsViewController: (TTThumbsViewController*)controller
       shouldNavigateToPhoto: (id<TTPhoto>)photo{
    return NO;
    
}

@end
