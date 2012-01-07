//
//  BMFacebookPost.h
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 05.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SBJSON.h"


typedef enum facebookPostType {
    kPostText,
    kPostImage
} facebookPostType;


@interface BMFacebookPost : NSObject {
    facebookPostType _type;
    NSMutableDictionary *_attachment;
    NSMutableDictionary *_media;
    NSMutableDictionary *_properties;
    UIImage *_image;
    NSString *_imageName;
}

@property (nonatomic, readonly) NSMutableDictionary *params;
@property (nonatomic, readonly) facebookPostType type;
@property (nonatomic, readonly) UIImage *image;


/**
 * In case you need to post to your user's wall and maybe want to include
 * an image from some URL, you should be using the following methods.
 */
- (id)initWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href;
- (void)setImageUrl:(NSString *)imageUrl withHref:(NSString *)href;
- (void)addPropertyWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href;

/**
 * In case you need to post an image to your user's album, init this
 * class with an image.
 */
- (id)initWithImage:(UIImage *)image;
- (void)setImageName:(NSString *)name;


@end
