//
//  AddExamplesToWordPreviewController.m
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddExamplesToWordPreviewController.h"
#import "AddWordModel.h"
#import "NSString+NSString_HTML_Utilities.h"

@implementation AddExamplesToWordPreviewController
@synthesize theWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.theWebView setBackgroundColor:[UIColor clearColor]];
    [self.theWebView setOpaque:NO];
    
    AddWordModel *model = [AddWordModel getInstance];
    NSString *examples = model.examples;
    if([model examples]){
        [self.theWebView loadHTMLString:[model.examples htmlFromMarkup] baseURL:nil];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTheWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
