# BMSocialShare

1. Post to Facebook or Twitter with an image and a comment by the user. Same via Email.
1. Share the AppStore or Android Market link for your App.

![Facebook iPhone](https://github.com/blockhaus/BMSocialShare/raw/documentation/header.png)


## Installation

1. Download the [framework](https://github.com/downloads/blockhaus/BMSocialShare/BMSocialShare.framework_v0.2.zip)!
1. Drag'n Drop the `BMSocialShare.framework` folder into your Xcode project
1. Add `MessageUI.framework` for Email to work
1. Add `Twitter.framework` for Twitter to work


## Facebook

1. Create an App on Facebook http://developers.facebook.com/apps
2. Copy your Facebook APP ID
3. In Xcode right click on your `Info.plist`, choose `Open As -> Source Code`
4. Insert the following snippet with your own Facebook APP ID:

```xml
    <key>CFBundleURLTypes</key>
    <array>
    <dict>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>           
    <string>fb123456789012345</string>
    </array>
    </dict>
    </array>
```

5. Add `#import <BMSocialShare/BMSocialShare.h>` to your `AppDelegate.m`

6. Overwrite `handleOpenURL` in your `AppDelegate.m`

```objective-c
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[BMSocialShare sharedInstance] handleOpenURL:url];
    }
```

7. Post to Facebook:

```objective-c
    BMFacebookPost *post = [[BMFacebookPost alloc] 
                            initWithTitle:@"Simple sharing via Facebook, Email and Twitter for iOS!" 
                            descriptionText:@"Posting to Facebook, Twitter and Email made dead simple on iOS. Simply include BMSocialShare as a framework and you are ready to go." 
                            andHref:@"https://github.com/blockhaus/BMSocialShare"];    
    
    [post setImageUrl:@"http://www.blockhausmedien.at/images/logo-new.gif" 
             withHref:@"http://www.blockhaus-media.com"];
    
    [post addPropertyWithTitle:@"Download" 
               descriptionText:@"github.com/blockhaus/BMSocialShare" 
                       andHref:@"http://github.com/blockhaus/BMSocialShare"];
    
    [post addPropertyWithTitle:@"Developed by" 
               descriptionText:@"blockhaus" 
                       andHref:@"http://www.blockhaus-media.com"];

    [[BMSocialShare sharedInstance] facebookPublish:post];
```


## Twitter

So far only iOS5+ is supported!

```objective-c
    [[BMSocialShare sharedInstance] twitterPublishText:@"Posting to Facebook, Twitter and Email made dead simple on iOS with BMSocialShare"
                                             withImage:nil
                                                andURL:[NSURL URLWithString:@"http://github.com/blockhaus/BMSocialShare"]
                                inParentViewController:self];
```

## EMail

```objective-c
    NSString *storePath = [[NSBundle mainBundle] pathForResource:@"blockhaus" ofType:@"png"];
        
    [[BMSocialShare sharedInstance] emailPublishText:@"Posting to Facebook, Twitter and Email made dead simple on iOS. Simply include BMSocialShare as a framework and you are ready to go.\nhttp://github.com/blockhaus/BMSocialShare"
                                              isHTML:YES
                                         withSubject:@"Simple sharing with BMSocialShare"
                                           withImage:storePath 
                              inParentViewController:self];
```


## Third Party

* This framework was created based on https://github.com/kstenerud/iOS-Universal-Framework.
* Graphics in the Examples were taken from http://365psd.com/day/240/ and http://subtlepatterns.com/
