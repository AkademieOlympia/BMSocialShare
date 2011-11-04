//
//  BMSocialShare.m
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 04.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//  www.blockhaus-media.com
//

#import "BMSocialShare.h"

@implementation BMSocialShare




+ (BMSocialShare *)sharedInstance
{
    static BMSocialShare *gInstance = NULL;
    
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}


- (id)init
{
    self = [super init];
    if (self) {
        
        // detect Facebook APP ID from bundle plist
        _appId = nil;
        NSArray *bundleURLTypesArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if (bundleURLTypesArray) {
            for (int bundleURLTypesArrayItem = 0; bundleURLTypesArrayItem < bundleURLTypesArray.count && _appId == nil; bundleURLTypesArrayItem++) {
                NSDictionary *bundleURLTypesDictionary = [bundleURLTypesArray objectAtIndex:bundleURLTypesArrayItem];
                NSArray *bundleURLSchemesArray = [bundleURLTypesDictionary objectForKey:@"CFBundleURLSchemes"];
                if (bundleURLSchemesArray) {
                    for (int bundleURLSchemesArrayItem = 0; bundleURLSchemesArrayItem < bundleURLTypesArray.count && _appId == nil; bundleURLSchemesArrayItem++) {
                        NSString *appIdCandidate = [bundleURLSchemesArray objectAtIndex:bundleURLSchemesArrayItem];
                        NSRange range = [appIdCandidate rangeOfString:@"fb"];
                        if(range.length == 2 && range.location == 0) {
                            _appId = [appIdCandidate substringFromIndex:2];
                            break;
                        }
                    }
                }
            }
        }
        
        // initialize facebook with default permissions
        if (_appId != nil) {
            [self enableFacebookWithPermissions:[NSArray arrayWithObjects: @"publish_stream", @"offline_access", nil]];
        }
        
        
        
    }
    return self;
}



/**
 * For Facebook Single Sign On (SSO) to work, this method needs to be called
 * from within your AppDelegate:
 *
 * - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 *     return [[BMSocialShare sharedInstance] handleOpenURL: url];
 * }
 * 
 */
- (BOOL)handleOpenURL:(NSURL *)url {
    if (_facebook != nil) {
        return [_facebook handleOpenURL:url];
    }
    return FALSE;
}




/**
 * Enable Facebook sharing with custom permissions.
 *
 */
- (void)enableFacebookWithPermissions:(NSArray *)permissions {

    if (_facebook == nil && _appId != nil) {
        _facebook = [[Facebook alloc] initWithAppId:_appId andDelegate:self];
        
        // try to load previous sessions
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }

    }

    _permissions = permissions;
    
}



/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void)facebookPublishWithParams:(NSMutableDictionary *)params {
    
    _params = [params copy];
    
    if (!_facebook.isSessionValid) {
        [_facebook authorize:_permissions];
        return;
    }
        
    [_facebook dialog:@"stream.publish" andParams:params andDelegate:self];
}





////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"publish successfully");
}




////////////////////////////////////////////////////////////////////////////////
// FBSessionDelegate


/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin {
    NSLog(@"fbDidLogin");
    
    // store this session for later use
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    if (_params) {
        [self facebookPublishWithParams:_params];
    }

}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"fbDidNotLogin");
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
    NSLog(@"fbDidLogout");
}



////////////////////////////////////////////////////////////////////////////////
// Memory Management


- (void)dealloc {

}





@end
