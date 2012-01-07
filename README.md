# BMSocialShare

Posting to Facebook, Twitter and Email made dead simple on iOS.

1. Post to Facebook or Twitter with an image and a comment by the user. Same via Email.
1. Share the AppStore or Android Market link for your App.

![Facebook iPhone](https://github.com/blockhaus/BMSocialShare/raw/documentation/header.png)


## Installation

1. Download the [framework](https://github.com/downloads/blockhaus/BMSocialShare/BMSocialShare.framework_v0.1.zip])!
1. Drag'n Drop the `BMSocialShare.framework` folder into your Xcode project
1. No other frameworks needed


## Facebook

1. Create an App on Facebook http://developers.facebook.com/apps
1. Copy your Facebook APP ID
1. In Xcode right click on your plist, choose `Open As -> Source Code`
1. Insert the following snippet with your own Facebook APP ID:

```
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

1. Add `#import <BMSocialShare/BMSocialShare.h>` to your `AppDelegate.m`

1. Overwrite `handleOpenURL` in your AppDelegate for SSO to work. More info can be found on https://developers.facebook.com/docs/mobile/ios/build/#implementsso

```
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[BMSocialShare sharedInstance] handleOpenURL:url];
    }
```

1. Post to Facebook:

```
    BMFacebookPost *post = [[BMFacebookPost alloc] 
                            initWithTitle:@"BMSocialShare" 
                            descriptionText:@"Simple sharing via Facebook, Email and Twitter for iOS!"
                            andHref:@"https://github.com/blockhaus/BMSocialShare"];
    
    [post setImageUrl:@"https://github.com/blockhaus/BMSocialShare/raw/documentation/header.png" 
             withHref:@"https://github.com/blockhaus/BMSocialShare"];
    
    [post addPropertyWithTitle:@"" 
               descriptionText:@""
                       andHref:@""];
    
    [post addPropertyWithTitle:@""
               descriptionText:@""
                       andHref:@""];
    
    [[BMSocialShare sharedInstance] facebookPublish:post];
```


## Twitter

So far only iOS5+ is supported!

```
    [[BMSocialShare sharedInstance] twitterPublishText:@"Simple sharing via Facebook, Email and Twitter for iOS!"
                                             withImage:nil
                                                andURL:[NSURL URLWithString:@""] 
                                inParentViewController:self];
```

## EMail

```
    [[BMSocialShare sharedInstance] emailPublishText:@"<bold>Simple sharing via Facebook, Email and Twitter for iOS!</bold>"
                                              isHTML:YES
                                         withSubject:@"BMSocialShare"
                                           withImage:nil
                              inParentViewController:self];
```


Third Party
---------

* This framework was created based on https://github.com/kstenerud/iOS-Universal-Framework.
* Graphics in the Examples were taken from http://365psd.com/day/240/ and http://subtlepatterns.com/
