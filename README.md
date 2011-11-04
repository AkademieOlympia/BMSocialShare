BMSocialShare
=============

This library is used to easily post to Facebook, Twitter and also Email on iOS.


Why?
---

The two main situations we face each time we develop an App is simple sharing on Facebook, Twitter and Email. There are only two things we need to do mainly:
1. Share a post on Facebook or Twitter with an image and a comment by the user. Same via Email.
2. We need to share the AppStore or Android Market link for the App.

We always just wanted to import a framework or library to our projects to do those simple tasks. But all other libraries come with loads of parameteres we never needed. So here is the solution FINALLY ;)


Facebook
--------
1. integrate url scheme / app id in plist. app id is automatically extracted from plist.
2. handle open url in app delegate

    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[BMSocialShare sharedInstance] handleOpenURL:url];
    }

3. To post something on Facebook you do the following:
    
    [[BMSocialShare sharedInstance] facebookPublishWithParams:params




Twitter
-------

For iOS5 the integrated `TWTweetComposeViewController` is used.

    [[BMSocialShare sharedInstance] twitterPublishText:@"Some text to tweet" withImage:nil andURL:nil inParentViewController:self];


EMail
-----



Thanks to
---------

This framework was created based on [https://github.com/kstenerud/iOS-Universal-Framework].
