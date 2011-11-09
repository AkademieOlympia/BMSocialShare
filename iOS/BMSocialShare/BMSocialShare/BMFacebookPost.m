//
//  BMFacebookPost.m
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 05.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import "BMFacebookPost.h"

@implementation BMFacebookPost

@synthesize type = _type, image = _image;


- (id)initWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href {

    if (self = [super init]) {
        
        _type = kPostText;
        _attachment = [[NSMutableDictionary alloc] init];
        
        if (title) {
            [_attachment setObject:title forKey:@"name"];
            
            if (href) {
                [_attachment setObject:href forKey:@"href"];   
            }
        }
        
        if (description) {
            [_attachment setObject:description forKey:@"description"];
        }
        
                
    }
    return self;
    
}


- (id)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _type = kPostImage;
        _image = image;
    }
    return self;
}


- (void)setImageName:(NSString *)name {
    _imageName = name;
}



- (void)setImageUrl:(NSString *)imageUrl withHref:(NSString *)href{
    
    if (_media == nil) {
        _media = [[NSMutableDictionary alloc] init];        
    }
    
    [_media setObject:@"image" forKey:@"type"];
    [_media setObject:imageUrl forKey:@"src"];
    [_media setObject:href forKey:@"href"];
    [_attachment setObject:[NSArray arrayWithObject:_media] forKey:@"media"];  
}


- (void)addPropertyWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href {
    
    if (_properties == nil) {
        _properties = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *prop = [[NSMutableDictionary alloc] init];
    [prop setObject:description forKey:@"text"];
    [prop setObject:href forKey:@"href"];
    [_properties setObject:prop forKey:title];
    [prop release];
}



- (NSMutableDictionary *)params {

    switch (_type) {
            
        case kPostImage:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:_image forKey:@"picture"];
            if (_imageName) {
                [params setObject:_imageName forKey:@"message"];
            }            
            return params;
        }
            
        default:
        case kPostText:
            if (_properties != nil && _attachment != nil) {
                [_attachment setObject:_properties forKey:@"properties"];
            }
            
            SBJSON *jsonWriter = [[SBJSON new] autorelease];
            NSString *attachmentString = [jsonWriter stringWithObject:_attachment];
            return [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    attachmentString, @"attachment", nil];
            
    }
    
    
}


////////////////////////////////////////////////////////////////////////////////
// Memory Management


- (void)dealloc {
    [_attachment release];
    [_media release];
    [_properties release];
    [_image release];
    [_imageName release];
    [super dealloc];
}




@end
