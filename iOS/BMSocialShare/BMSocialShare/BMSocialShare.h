//
//  BMSocialShare.h
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 04.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//  www.blockhaus-media.com
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"




@interface BMSocialShare : NSObject <FBDialogDelegate, FBSessionDelegate> {
    Facebook *_facebook;
    NSString *_appId;
    NSArray *_permissions;
    NSMutableDictionary *_params;
}


+ (BMSocialShare *) sharedInstance;


/* Facebook */
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)enableFacebookWithPermissions:(NSArray *)permissions;
- (void)facebookPublishWithParams:(NSMutableDictionary *)params;


/* Twitter */
- (void)twitterPublishText:(NSString *)text 
                 withImage:(UIImage *)image 
                    andURL:(NSURL *)url 
    inParentViewController:(UIViewController *)parentViewController;


/* Email */




@end


