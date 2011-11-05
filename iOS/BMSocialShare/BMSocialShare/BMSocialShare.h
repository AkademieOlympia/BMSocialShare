//
//  BMSocialShare.h
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 04.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//  www.blockhaus-media.com
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"
#import "BMFacebookPost.h"




@interface BMSocialShare : NSObject <FBDialogDelegate, FBSessionDelegate, MFMailComposeViewControllerDelegate> {
    Facebook *_facebook;
    NSString *_appId;
    NSArray *_permissions;
    BMFacebookPost *_post;
}


+ (BMSocialShare *) sharedInstance;


/* Facebook */
- (BOOL)facebookHandleOpenURL:(NSURL *)url;
- (void)facebookPermissions:(NSArray *)permissions;
- (void)facebookPublish:(BMFacebookPost *)post;


/* Twitter */
- (void)twitterPublishText:(NSString *)text 
                 withImage:(UIImage *)image 
                    andURL:(NSURL *)url 
    inParentViewController:(UIViewController *)parentViewController;


/* Email */
-(void)emailPublishText:(NSString *)text
            withSubject:(NSString *)subject
              withImage:(NSString *)imagePath 
 inParentViewController:(UIViewController *)parentViewController;


@end


