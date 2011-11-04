//
//  BMSocialShare.h
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 04.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"




@interface BMSocialShare : NSObject <FBDialogDelegate, FBSessionDelegate> {
    Facebook *_facebook;
    NSString *_appId;
    NSArray *_permissions;
    NSString *_imageURL;
}

+ (BMSocialShare *) sharedInstance;


/* Facebook */
- (void)enableFacebookWithAppId:(NSString *)appId;
- (void)enableFacebookWithAppId:(NSString *)appId andPermissions:(NSArray *)permissions;
- (void)facebookPublishToStreamWithParams:(NSMutableDictionary *)params andImageAtURL:(NSString *)imageUrl;


/* Twitter */


/* Email */




@end


