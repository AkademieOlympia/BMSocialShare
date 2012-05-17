# BMSocialShare

1. Share to Facebook, Twitter or Email and attach an image!
1. Supports **"Single Click Sharing"** - BMSocialShare logs your user in to Facebook, in case no credentials are provided and sends the post afterwards.
1. Share full size images to Facebook walls
1. BMSocialShare is available as framwork for simple integration or as a static library for more advanced use cases
2. Questions? Contact me on Twitter [@vinzenzweber](http://twitter.com/vinzenzweber)


![Facebook iPhone](https://github.com/blockhaus/BMSocialShare/raw/documentation/header.png)

## Quick install: Use the framework version

1. Download the [framework](https://github.com/downloads/blockhaus/BMSocialShare/BMSocialShare.framework_v0.2.zip)!
1. Drag'n drop the `BMSocialShare.framework` folder into your Xcode project
1. Add `MessageUI.framework` for Email to work
1. Add `Twitter.framework` for Twitter to work


## Advanced install: Use the static library

1. In your git repository's root folder do `git submodule add git@github.com:blockhaus/BMSocialShare.git`
1. Afterwards download all submodules `git submodule update --init --recursive`
2. Now follow the instructions in the screenshots:

![Xcode screenshot](https://github.com/blockhaus/BMSocialShare/raw/documentation/BMSocialShare_Xcode_0.png)
![Xcode screenshot](https://github.com/blockhaus/BMSocialShare/raw/documentation/BMSocialShare_Xcode_1.png)
![Xcode screenshot](https://github.com/blockhaus/BMSocialShare/raw/documentation/BMSocialShare_Xcode_2.png)
![Xcode screenshot](https://github.com/blockhaus/BMSocialShare/raw/documentation/BMSocialShare_Xcode_3.png)
![Xcode screenshot](https://github.com/blockhaus/BMSocialShare/raw/documentation/BMSocialShare_Xcode_4.png)

## Facebook

1. Create an App on Facebook http://developers.facebook.com/apps
1. Copy your Facebook APP ID
1. In Xcode right click on your `Info.plist`, choose `Open As -> Source Code`
1. Insert the following snippet with your own Facebook APP ID:

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
![plist source](https://github.com/blockhaus/BMSocialShare/raw/documentation/plist_source.png)

1. Add `#import <BMSocialShare/BMSocialShare.h>` to your `AppDelegate.m`
1. Overwrite `handleOpenURL:` and `applicationDidBecomeActive:` in your `AppDelegate.m`

```objective-c
    // for iOS prior 4.2
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[BMSocialShare sharedInstance] facebookHandleOpenURL:url];
    }
    
    // for iOS > 4.2 make sure you use
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        return [[BMSocialShare sharedInstance] facebookHandleOpenURL:url];
    }
    
    // extend the access token
    - (void)applicationDidBecomeActive:(UIApplication *)application
    {
        [[BMSocialShare sharedInstance] facebookExendAccessToken];
    }
```

1. Post to Facebook:

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

8) Or share an image in full size:

```objective-c
    BMFacebookPost *post = [[BMFacebookPost alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
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

## Apps using BMSocialShare

* [DOTZ Tuning Wheels Configurator](http://itunes.apple.com/app/id403985530)
* [Dotz Tuning Wheels Configurator HD](http://itunes.apple.com/app/id436998470)
* [AEZ Magazine](http://itunes.apple.com/app/id480123902)


## Third Party

* This framework was created based on https://github.com/kstenerud/iOS-Universal-Framework.
* Graphics in the Examples were taken from http://365psd.com/day/240/ and http://subtlepatterns.com/
