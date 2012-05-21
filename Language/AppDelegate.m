//
//  AppDelegate.m
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseMenuController.h"
#import "ManagedObjectsDao.h"
#import "FlashcardModel.h"
#import "DaoInteractor.h"
#import "Section.h"
#import "FlashCard.h"
@interface AppDelegate ()
-(void)goToSpecificSectionWithUserInfo:(NSDictionary *)dictionary;
-(void)uncaughtExceptionHandler:(NSException *)exception;
@end
@implementation AppDelegate

@synthesize window = _window;
@synthesize stackedController = _stackedController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    [FlashcardModel getInstance];
    
    BaseMenuController *baseMenuController = [[BaseMenuController alloc] init];
    
    UINavigationController *baseNavigator = [[UINavigationController alloc] initWithRootViewController:baseMenuController];
    
    self.stackedController = [[PSStackedViewController alloc] initWithRootViewController:baseNavigator];
    
    self.stackedController.defaultShadowAlpha = .6;
    
    self.window.rootViewController = self.stackedController;
    

    
    // Override point for customization after application launch.
    // Handle launching from a notification
    UILocalNotification *localNotif =[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        [self goToSpecificSectionWithUserInfo:localNotif.userInfo];
    }
    
    return YES;
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    [self goToSpecificSectionWithUserInfo:notif.userInfo];
}

-(void)goToSpecificSectionWithUserInfo:(NSDictionary *)dictionary{
    NSNumber *uid = [dictionary valueForKey:@"sectionID"];
    NSArray *allSections = [DaoInteractor getInstance].allUserCreatedSections;
    NSArray *words;
    for (int i = 0; i < allSections.count ; i ++) {
        Section *userSection = [allSections objectAtIndex:i];
        if(userSection.uniqueID.doubleValue == uid.doubleValue){
           // words = userSection.words.allObjects;
            break;
        }
    }
    if(!words)return;
    FlashCard *flashCard = [[FlashCard alloc] initWithFlashcardWords:words];
    [self.stackedController presentModalViewController:flashCard animated:YES];
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
