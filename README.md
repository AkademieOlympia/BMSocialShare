BMSocialShare
=============

Posting to Facebook, Twitter and Email made dead simple on iOS.


![Facebook iPhone](https://github.com/blockhaus/BMSocialShare/raw/framework/images/facebook_iPhone.png)
![Facebook Stream](https://github.com/blockhaus/BMSocialShare/raw/framework/images/facebook_stream.png)


Why?
---

For most Apps we develop there are only two things we need to do mainly:
1. Share a post on Facebook or Twitter with an image and a comment by the user. Same via Email.
2. We need to share the AppStore or Android Market link for the App.

All other sharing libraries come with loads of parameteres we never needed.


Facebook
--------

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


1. Overwrite `handleOpenURL` in your AppDelegate for SSO to work:

    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[BMSocialShare sharedInstance] handleOpenURL:url];
    }

1. Post to Facebook:
    
    [[BMSocialShare sharedInstance] facebookPublishWithParams:params




Twitter
-------

2. Integrate `Twitter.framework``


For iOS5 the integrated `TWTweetComposeViewController` is used.

    [[BMSocialShare sharedInstance] twitterPublishText:@"Some text to tweet" withImage:nil andURL:nil inParentViewController:self];


EMail
-----



Thanks to
---------

This framework was created based on [https://github.com/kstenerud/iOS-Universal-Framework].
