//
//  FlickrPhotoViewerViewController.m
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoViewerViewController.h"
#import "FlickrPhoto.h"

@interface FlickrPhotoViewerViewController ()
@property(nonatomic, retain)FlickrPhoto *photo;
@property(nonatomic, retain)NSMutableData *imageData;
-(void)configureImageViewFromPhoto:(FlickrPhoto *)photo;
@end

@implementation FlickrPhotoViewerViewController
@synthesize imageView;
@synthesize photo;
@synthesize imageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithFlickrPhoto:(FlickrPhoto *)flickrPhoto{
    if([super init]){
        self.photo = flickrPhoto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageView setAlpha:0];
    [self configureImageViewFromPhoto:self.photo];
    [self showHud:YES];
    // Do any additional setup after loading the view from its nib.
}

-(void)configureImageViewFromPhoto:(FlickrPhoto *)photo{
    NSURL *url = [NSURL URLWithString:photo.fullSizePhoto];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    // UIImage *image = [[UIImage alloc] init];
    imageView.alpha = 0;
    self.imageData = [[NSMutableData alloc] init];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    self.imageData = nil;
    self.photo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self showHud:NO];
    UIImage *uiImage = [UIImage imageWithData:self.imageData];
    self.imageView.image = uiImage;
    [UIView animateWithDuration:.5 animations:^{
        [self.imageView setAlpha:1];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
