//
//  StudyStylePreferencePane.h
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBAFormViewController.h"

@interface StudyStylePreferencePane : IBAFormViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
