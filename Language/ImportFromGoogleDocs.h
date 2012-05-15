//
//  ImportFromGoogleDocs.h
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleDocsDao.h"
#import "GoogleDocsDaoResponder.h"

@interface ImportFromGoogleDocs : UIViewController <GoogleDocsDaoResponder, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain) GoogleDocsDao *dao;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
