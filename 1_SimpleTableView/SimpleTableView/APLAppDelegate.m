
/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Application delegate that sets up the root view controller.
 */

#import "APLAppDelegate.h"
#import "APLBrandsViewController.h"

@implementation APLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //Create the window for our application
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Load the nib by ourself
    APLBrandsViewController* controller = [[APLBrandsViewController alloc] init];
    
    //Create a navigation controller
    UINavigationController* navigationCL = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    self.window.rootViewController = navigationCL;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
@end
