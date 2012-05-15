//
//  CreateGroup.h
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedObjectsDao.h"
#import "IBAFormViewController.h"
#import "FormsBaseViewController.h"

@interface CreateGroup : FormsBaseViewController{
    ManagedObjectsDao *moDao;
}

@property (strong, nonatomic) ManagedObjectsDao *maDao;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
