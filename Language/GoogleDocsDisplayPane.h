//
//  GoogleDocsDisplayPane.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleDocsDaoResponder.h"
#import "IBAFormViewController.h"

@interface GoogleDocsDisplayPane : IBAFormViewController <GoogleDocsDaoResponder>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, assign) BOOL shouldGoToImport;
@end
