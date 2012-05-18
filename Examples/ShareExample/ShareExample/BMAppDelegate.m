//
//  BMAppDelegate.m
//  ShareExample
//
//  Created by Vinzenz-Emanuel Weber on 05.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import "BMAppDelegate.h"

#import "BMViewController.h"

@implementation BMAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    self.viewController = [[[BMViewController alloc] initWithNibName:@"BMViewController" bundle:nil] autorelease];
    
    if ([self.window respondsToSelector:@selector(setRootViewController:)]) {
        self.window.rootViewController = self.viewController;
    } else {
        [self.window addSubview:self.viewController.view];
    }

    [self.window makeKeyAndVisible];
    return YES;
}


// for iOS prior 4.2 make sure you use
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // include this for Single Sign On (SSO) to work
    // https://developers.facebook.com/docs/mobile/ios/build/#implementsso
    return [[BMSocialShare sharedInstance] facebookHandleOpenURL:url];
}


// for iOS > 4.2 make sure you use
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[BMSocialShare sharedInstance] facebookHandleOpenURL:url];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     THIS CALL IS ESSENTIAL TO KEEP ACCESS TO FACEBOOK!
     MAKE SURE YOU IMPLEMENT IT IN YOUR OWN APP! ;)
     */
    [[BMSocialShare sharedInstance] facebookExendAccessToken];

}


@end
