BMSocialShare
=============

Posting to Facebook, Twitter and Email made dead simple on iOS.


![Facebook iPhone](https://github.com/blockhaus/BMSocialShare/raw/documentation/header.png)



Why?
---

For most Apps we develop there are only two things we need to do mainly:
1. Share a post on Facebook or Twitter with an image and a comment by the user. Same via Email.
1. We need to share the AppStore or Android Market link for the App.

All other sharing libraries come with loads of parameteres we never needed.

Quick Start
---
1. Download the [framework][https://github.com/downloads/blockhaus/BMSocialShare/BMSocialShare.framework_v0.1.zip]!
1. 


Facebook
--------

1. Create an App on Facebook http://developers.facebook.com/apps   
1. Right click on your project's plist, choose `Open As -> Source Code` and insert the following snippet with your own Facebook APP ID:

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


1. Overwrite `handleOpenURL` in your AppDelegate for SSO to work. More info can be found on https://developers.facebook.com/docs/mobile/ios/build/#implementsso

    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[BMSocialShare sharedInstance] handleOpenURL:url];
    }

1. Post to Facebook:
    
    [[BMSocialShare sharedInstance] facebookPublishWithParams:params




Twitter
-------

2. Integrate `Twitter.framework`


For iOS5 the integrated `TWTweetComposeViewController` is used.
```
    [[BMSocialShare sharedInstance] twitterPublishText:@"Some text to tweet" 
                                             withImage:nil 
                                                andURL:nil 
                                inParentViewController:self];
```

EMail
-----



Third Party
---------

* This framework was created based on [https://github.com/kstenerud/iOS-Universal-Framework].
* Graphics in the Examples were taken from http://365psd.com/day/240/ and http://subtlepatterns.com/
