//
//  BaseViewController.h
//  Language
//
//  Created by Eric Cancil on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoInteractor.h"
#import "MBProgressHUD.h"
#import "LocalizationStringConstants.h"

@interface BaseViewController : UIViewController
@property (nonatomic, retain) DaoInteractor *daoInteractor;
@property (nonatomic, retain) MBProgressHUD *hud;
-(Word *)getWordFromCollection:(NSArray *)collection ByRow:(int)row;
- (void)showHud:(BOOL)show;
@end
