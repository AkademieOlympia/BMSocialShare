//
//  BMFacebookPost.h
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 05.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"

@interface BMFacebookPost : NSObject {
    NSMutableDictionary *_attachment;
    NSMutableDictionary *_media;
    NSMutableDictionary *_properties;
}

@property (nonatomic, readonly) NSMutableDictionary *params;

- (id)initWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href;
- (void)setImageUrl:(NSString *)imageUrl withHref:(NSString *)href;
- (void)addPropertyWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href;

@end
