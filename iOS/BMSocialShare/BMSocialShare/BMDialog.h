//
//  BMDialog.h
//  mag-engine
//
//  Created by Vinzenz-Emanuel Weber on 08.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur OG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BMFacebookPost.h"
#import "Facebook.h"



@protocol BMDialogDelegate;

/**
 * Do not use this interface directly, instead, use dialog in Facebook.h
 *
 * Facebook dialog interface for start the facebook webView UIServer Dialog.
 */

@interface BMDialog : UIView <UIWebViewDelegate, FBRequestDelegate> {
    id<BMDialogDelegate> _delegate;
    UIActivityIndicatorView* _spinner;
    UIButton* _closeButton;
    UIInterfaceOrientation _orientation;
    BOOL _showingKeyboard;
    UIView *_containerView;
    BMFacebookPost *_post;
    Facebook *_facebook;

    UIImageView *_imageView;
    UITextField *_textField;
    UIButton *_cancelButton;
    UIButton *_okButton;

    // Ensures that UI elements behind the dialog are disabled.
    UIView* _modalBackgroundView;
}

/**
 * The delegate.
 */
@property(nonatomic,assign) id<BMDialogDelegate> delegate;

- (id)initWithFacebook:(Facebook *)Facebook
                  post:(BMFacebookPost *)post
              delegate:(id <BMDialogDelegate>) delegate;


/**
 * Displays the view with an animation.
 *
 * The view will be added to the top of the current key window.
 */
- (void)show;

/**
 * Hides the view and notifies delegates of success or cancellation.
 */
- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated;

/**
 * Hides the view and notifies delegates of an error.
 */
- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;

/**
 * Subclasses should override to process data returned from the server in a 'fbconnect' url.
 *
 * Implementations must call dismissWithSuccess:YES at some point to hide the dialog.
 */
- (void)dialogDidSucceed:(NSURL *)url;

/**
 * Subclasses should override to process data returned from the server in a 'fbconnect' url.
 *
 * Implementations must call dismissWithSuccess:YES at some point to hide the dialog.
 */
- (void)dialogDidCancel:(NSURL *)url;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *Your application should implement this delegate
 */
@protocol BMDialogDelegate <NSObject>

@optional

/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(BMDialog *)dialog;

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(BMDialog *)dialog;

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(BMDialog*)dialog didFailWithError:(NSError *)error;


@end
