//
//  BaseViewController.m
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end
@implementation BaseViewController
@synthesize daoInteractor;

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

-(Word *)getWordFromCollection:(NSArray *)collection ByRow:(int)row{
    Word *word;
    
    id objectAtIndex = [collection objectAtIndex:row];
    
    if([objectAtIndex class] == [Word class] || [objectAtIndex class] == [SQLWord class]){
        //if we get here this is a cached and indexed session so well only get the ID
        Word *actualWord = (Word *)objectAtIndex;
        word = [WordCache getWordForKey:actualWord.uniqueID];
        
    }else{
        //else this is a default section and we'll get the actual word
        word = [WordCache getWordForKey:(NSNumber *)objectAtIndex];
    }
    return word;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.daoInteractor = [DaoInteractor getInstance];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
