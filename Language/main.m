//
//  main.m
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

/*int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}*/

int main(int argc, char *argv[]) {
    
    int toReturn;
    @autoreleasepool {
         toReturn =UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }

    int retVal = -1;
    @try {
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    @catch (NSException* exception) {
        NSLog(@"Uncaught exception: %@", exception.description);
        NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    }
    //[pool release];
    return toReturn;
}