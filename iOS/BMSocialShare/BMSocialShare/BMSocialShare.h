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
#import "BMDialog.h"



@protocol BMSocialShareDelegate <NSObject>

@optional

/**
 * Called once Facebook finished logging in.
 */
- (void)facebookDidLogin;

@end



@interface BMSocialShare : NSObject <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate, MFMailComposeViewControllerDelegate, BMDialogDelegate> {
    id <BMSocialShareDelegate> _delegate;
    int _currentAPICall;
    Facebook *_facebook;
    NSString *_appId;
    NSArray *_permissions;
    UIViewController *_emailParentViewController;
}


@property (nonatomic, readonly) Facebook *facebook;
@property (nonatomic, assign) id <BMSocialShareDelegate> delegate;

+ (BMSocialShare *) sharedInstance;


/* Facebook */
- (void)facebookLogin;
- (void)facebookLogout;
- (BOOL)facebookHandleOpenURL:(NSURL *)url;
- (void)facebookPublish:(BMFacebookPost *)post;
- (void)facebookExtendAccessToken;


/* Twitter */
- (void)twitterPublishText:(NSString *)text 
                 withImage:(UIImage *)image 
                    andURL:(NSURL *)url 
    inParentViewController:(UIViewController *)parentViewController;


/* Email */
-(void)emailPublishText:(NSString *)text
                 isHTML:(BOOL)isHTML
            withSubject:(NSString *)subject
              withImage:(NSString *)imagePath 
 inParentViewController:(UIViewController *)parentViewController;


@end


