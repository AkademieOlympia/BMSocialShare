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




@interface BMSocialShare : NSObject <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate, MFMailComposeViewControllerDelegate> {
    int _currentAPICall;
    Facebook *_facebook;
    NSString *_appId;
    NSArray *_permissions;
    UIViewController *_emailParentViewController;
}


+ (BMSocialShare *) sharedInstance;


/* Facebook */
- (BOOL)facebookHandleOpenURL:(NSURL *)url;
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


