//
//  BMSocialShare.m
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 04.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//  www.blockhaus-media.com
//

#import "BMSocialShare.h"


#define kFacebookPostParams @"FacebookPostParams"



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
            NSLog(@"BMSocialShare: Using Facebook APP ID: %@", _appId);
            [self facebookPermissions:[NSArray arrayWithObjects: @"publish_stream", @"offline_access", nil]];
        }
        
        
        
    }
    return self;
}



////////////////////////////////////////////////////////////////////////////////
// PRIVATE
////////////////////////////////////////////////////////////////////////////////


-(void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}






////////////////////////////////////////////////////////////////////////////////
// PUBLIC
////////////////////////////////////////////////////////////////////////////////



/**
 * For Facebook Single Sign On (SSO) to work, this method needs to be called
 * from within your AppDelegate:
 *
 * - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 *     return [[BMSocialShare sharedInstance] facebookHandleOpenURL: url];
 * }
 * 
 */
- (BOOL)facebookHandleOpenURL:(NSURL *)url {
    if (_facebook != nil) {
        return [_facebook handleOpenURL:url];
    }
    return FALSE;
}




/**
 * Enable Facebook sharing with custom permissions.
 *
 */
- (void)facebookPermissions:(NSArray *)permissions {
    
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

- (void)facebookPublish:(BMFacebookPost *)post {
    
    if (!_facebook.isSessionValid) {
        [[NSUserDefaults standardUserDefaults] setObject:post.params forKey:kFacebookPostParams];
        [_facebook authorize:_permissions];
        return;
    }
    
    [_facebook dialog:@"stream.publish" andParams:post.params andDelegate:self];
}


/**
 * In case the user does not want to login to Facebook or
 * somehow is cancelling the post, we need to remove the post
 * from user defaults.
 */
- (void)deleteLastPostFromUserDefaults {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = [defaults dictionaryForKey:kFacebookPostParams];
    if (params) {
        [defaults removeObjectForKey:kFacebookPostParams];
    }
    [defaults synchronize];
    
}




////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate


/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"dialogDidComplete");
    [self deleteLastPostFromUserDefaults];
}


/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"dialogDidNotComplete");
    [self deleteLastPostFromUserDefaults];
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
    
    // is there a post that was created before we logged in?
    NSDictionary *params = [defaults dictionaryForKey:kFacebookPostParams];
    if (params) {
        NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
        // send it now that we are logged in!
        [_facebook dialog:@"stream.publish" andParams:mutableParams andDelegate:self];
    }
    
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"fbDidNotLogin");
    [self deleteLastPostFromUserDefaults];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
    NSLog(@"fbDidLogout");
    [self deleteLastPostFromUserDefaults];
}





////////////////////////////////////////////////////////////////////////////////
// Twitter
////////////////////////////////////////////////////////////////////////////////




/**
 * Send a tweet. Add an image and/or URL, otherwise set them nil.
 *
 */
-(void)twitterPublishText:(NSString *)text 
                withImage:(UIImage *)image 
                   andURL:(NSURL *)url 
   inParentViewController:(UIViewController *)parentViewController {

    // check if we can tweet using iOS5 built-in Twitter account
    BOOL cansend = FALSE;
	Class tweetComposeViewControllerClass = (NSClassFromString(@"TWTweetComposeViewController"));
	if (tweetComposeViewControllerClass != nil) { 			
		if ([tweetComposeViewControllerClass canSendTweet]) {
			cansend = TRUE;
		}
	}

    
	if (cansend) {
        
        // Set up the built-in twitter composition view controller.
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        if (text) {
            [tweetViewController setInitialText:text];
        }
        
        if (image) {
            [tweetViewController addImage:image];
        }
        
        if (url) {
            [tweetViewController addURL:url];
        }
                
                
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
/*
            NSString *output;
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                    output = @"Tweet cancelled.";
                    break;
                case TWTweetComposeViewControllerResultDone:
                    output = @"Tweet done.";
                    break;
                default:
                    break;
            }
            
            [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
*/
            // Dismiss the tweet composition view controller.
            [parentViewController dismissModalViewControllerAnimated:YES];
        }];
        
        // Present the tweet composition view controller modally.
        [parentViewController presentModalViewController:tweetViewController animated:YES];
        
        
    } else {
        [self showAlertWithTitle:@"Error" andMessage:@"Twitter is not supported on this device!"];
    }
}




////////////////////////////////////////////////////////////////////////////////
// Email
////////////////////////////////////////////////////////////////////////////////




-(void)emailPublishText:(NSString *)text
            withSubject:(NSString *)subject
              withImage:(NSString *)imagePath 
 inParentViewController:(UIViewController *)parentViewController {
    
    
    // check how we can send emails
    BOOL cansend = FALSE;
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) { 			
		if ([mailClass canSendMail]) {
			cansend = TRUE;
		}
	}
    
    
    if (cansend) {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        if (subject) {
            [picker setSubject:subject];
        }

        if (text) {
            [picker setMessageBody:text isHTML:NO];
        }
        
        if (imagePath) {
            
            NSString *filename = [imagePath lastPathComponent];
            NSString *fileExtension = [filename pathExtension];
            NSString *mimeType = [NSString stringWithFormat:@"image/%@", fileExtension];
            
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            [picker addAttachmentData:imageData mimeType:mimeType fileName:filename];
            
        }

/*
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
        NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
        
        [picker setToRecipients:toRecipients];
        [picker setCcRecipients:ccRecipients];	
        [picker setBccRecipients:bccRecipients];
*/

        [parentViewController presentModalViewController:picker animated:YES];
        [picker release];
        
        
    } else {
        
        
/*
 NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
*/
        
        NSMutableString *msg = [NSMutableString stringWithString:@"mailto:"];

        if (subject) {
            [msg appendFormat:@"subject=%@", subject];            
        }
        
        if (text) {
            [msg appendFormat:@"&body=%@", text];            
        }

        NSString *email = [msg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];

    }
    
}


/*

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message.text = @"Result: failed";
			break;
		default:
			message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
*/



////////////////////////////////////////////////////////////////////////////////
// Memory Management


- (void)dealloc {
}





@end
