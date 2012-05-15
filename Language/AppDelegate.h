//
//  AppDelegate.h
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSStackedView.h"

#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    PSStackedViewController *stackedController;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PSStackedViewController *stackedController;

@end
