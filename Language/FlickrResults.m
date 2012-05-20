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
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "Word.h"
#import "FlickrPhotoViewerViewController.h"

@interface FlickrResults ()
-(UIImageView *)getConfiguredImageViewFromPhoto:(FlickrPhoto *)photo;
@property(nonatomic, retain) NSMutableDictionary *tokenDictionary;
@property(nonatomic, retain) NSMutableDictionary *imageDataDictionary;
@property(nonatomic, retain) FlickrImageSearchDao *flickrDao;
@property(nonatomic, assign) int totalLoaded;
@property(nonatomic, retain) NSArray *allImages;
@property(nonatomic, retain) AddWordModel *model;
@end

@implementation FlickrResults
@synthesize scrollView;
@synthesize flickrDao;
@synthesize tokenDictionary;
@synthesize imageDataDictionary;
@synthesize totalLoaded;
@synthesize allImages;
@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithModel:(AddWordModel *)theModel{
    if([super init]){
        self.model = theModel;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    tokenDictionary = [[NSMutableDictionary alloc] init];
    imageDataDictionary = [[NSMutableDictionary alloc] init];
    flickrDao = [[FlickrImageSearchDao alloc] initWithResponder:self];
    //NSString *searchString = [NSString stringWithFormat:@"%@,%@,%@", model.word ? model.word.language1 : model.word.language1, model.word ? model.word.language2 : model.language2, model.word ? model.word.language2supplemental : model.language2Supplemental];
    NSString *searchString = [NSString stringWithFormat:@"%@", model.word ? model.word.language1 : model.language1];
    [flickrDao searchForImagesByString:searchString];
    [super showHud:YES];
    // Do any additional setup after loading the view from its nib.
}
     
-(void)imagesDidLoad:(NSArray *)images{
    [self showHud:NO];
    self.allImages = images;
    int i = 0;
    int count = images.count;
    int const gap = 10;
    int const thumbWidth = 75;
    int const thumbHeight = 75;
    int row = -1;
    int rowY = 0;
    for (i; i < count; i ++) {
        FlickrPhoto *flickrPhoto = (FlickrPhoto *)[images objectAtIndex:i];
        UIImageView *imageView = [self getConfiguredImageViewFromPhoto:flickrPhoto];
        imageView.tag = i;
        int rowIndexer = i % 3;
        if(rowIndexer == 0){
            row ++;
            rowY = ((row + 1) * gap) + (row * thumbHeight);
            if(rowY == 0)rowY = gap;
        }
        switch (rowIndexer) {
            case 0:
                imageView.frame = CGRectMake(gap, rowY, thumbWidth, thumbHeight);
                break;
            case 1:
                imageView.frame = CGRectMake((thumbWidth + gap) +(self.scrollView.bounds.size.width - (gap * 2) - (thumbWidth * 2) - thumbWidth) /2, rowY, thumbWidth, thumbHeight);
                break;    
            case 2:
                imageView.frame = CGRectMake((self.scrollView.bounds.size.width - thumbWidth - gap), rowY, thumbWidth, thumbHeight);
                break;
        }
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, imageView.frame.origin.y + imageView.frame.size.height + gap);
        NSLog(@"");
    }
}

-(UIImageView *)getConfiguredImageViewFromPhoto:(FlickrPhoto *)photo{
    NSURL *url = [NSURL URLWithString:photo.thumbnail];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
   // UIImage *image = [[UIImage alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.alpha = 0;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.masksToBounds = NO;
    imageView.layer.cornerRadius = 5; // if you like rounded corners
    imageView.layer.shadowOffset = CGSizeMake(2, 2);
    imageView.layer.shadowRadius = 2;
    imageView.layer.shadowOpacity = 0.5;
    [tokenDictionary setObject:imageView forKey:request];
    [imageDataDictionary setObject:[[NSMutableData alloc] init] forKey:request];
    return imageView;
}

-(void)didTap:(UITapGestureRecognizer *)gestureRecognizer{
    UIImageView *view = gestureRecognizer.view;
    if(view){
        FlickrPhoto *flickrPhoto = [self.allImages objectAtIndex:view.tag];
        FlickrPhotoViewerViewController *viewer = [[FlickrPhotoViewerViewController alloc] initWithFlickrPhoto:flickrPhoto];
        [self.navigationController pushViewController:viewer animated:YES];
    }
    //CGPoint loc = [gestureRecognizer locationInView:view];
    //UIView* subview = [view hitTest:loc withEvent:nil];
   // UIImageView *imageView = (UIImageView *)sender;
    
    
}
                                     

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSMutableData *mutableData = (NSMutableData *)[imageDataDictionary objectForKey:connection.originalRequest];
    [mutableData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.totalLoaded ++;
    if(self.totalLoaded == allImages.count - 1){
        //[self performSelectorOnMainThread:@selector(showHud) withObject:nil waitUntilDone:NO];   
    }
    NSMutableData *mutableData = (NSMutableData *)[imageDataDictionary objectForKey:connection.originalRequest];
    UIImageView *imageView = [tokenDictionary objectForKey:connection.originalRequest];
    [imageView setImage:[UIImage imageWithData:mutableData]];
    [UIView animateWithDuration:.5 animations:^{
        [imageView setAlpha:1];
    }];
    [imageView setUserInteractionEnabled:YES];
    UIGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [imageView addGestureRecognizer:gr];
    gr.delegate = self;
}

-(void)dealloc{
    imageDataDictionary = nil;
    tokenDictionary = nil;
    allImages = nil;
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}



@end
