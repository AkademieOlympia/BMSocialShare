//
//  BMSocialShare.m
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 04.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
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

    }
    return self;
}


/**
 * Enable Facebook sharing with default permissions for publishing.
 *
 */
- (void)enableFacebookWithAppId:(NSString *)appId {
    [self enableFacebookWithAppId:appId andPermissions:[NSArray arrayWithObjects: @"publish_stream", @"offline_access", nil]];
}


/**
 * Enable Facebook sharing with custom permissions.
 *
 */
- (void)enableFacebookWithAppId:(NSString *)appId andPermissions:(NSArray *)permissions {
    
    _facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];
    _permissions = permissions;
    
    // try to load previous sessions
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
}



/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void)facebookPublishToStreamWithParams:(NSMutableDictionary *)params andImageAtURL:(NSString *)imageUrl {
    
    _imageURL = [imageUrl copy];
    
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
    
//    [_facebook publishStreamWithImageAtURL:_imageURL];
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
