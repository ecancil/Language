//
//  FormsBaseDataSource.m
//  Language
//
//  Created by Eric Cancil on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FormsBaseDataSource.h"

@implementation FormsBaseDataSource
@synthesize daoInteractor;


-(id)initWithModel:(id)model{
    self.daoInteractor = [DaoInteractor getInstance];
    return [super initWithModel:model];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
