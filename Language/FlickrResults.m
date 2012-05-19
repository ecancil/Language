//
//  FlickrResults.m
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrResults.h"
#import "FlickrImageSearchDao.h"
#import "FlickrPhoto.h"

@interface FlickrResults ()
-(UIImageView *)getConfiguredImageViewFromPhoto:(FlickrPhoto *)photo;
@property(nonatomic, retain) FlickrImageSearchDao *flickrDao;
@end

@implementation FlickrResults
@synthesize scrollView;
@synthesize flickrDao;

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
    int i = 0;
    int count = images.count;
    int const gap = 5;
    int const thumbWidth = 75;
    int const thumbHeight = 75;
    int row = -1;
    int rowY = 0;
    for (i; i < count; i ++) {
        FlickrPhoto *flickrPhoto = (FlickrPhoto *)[images objectAtIndex:i];
        UIImageView *imageView = [self getConfiguredImageViewFromPhoto:flickrPhoto];
        int rowIndexer = i % 3;
        if(rowIndexer == 0){
            row ++;
            rowY = (row * gap) + (row * thumbHeight);
        }
        imageView.bounds = CGRectMake(gap, rowY, thumbWidth, thumbHeight);
        [self.view addSubview:imageView];
        NSLog(@"");
    }
}

-(UIImageView *)getConfiguredImageViewFromPhoto:(FlickrPhoto *)photo{
    NSURL *url = [NSURL URLWithString:photo.thumbnail];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
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



@end
