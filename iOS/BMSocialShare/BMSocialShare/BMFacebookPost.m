//
//  BMFacebookPost.m
//  BMSocialShare
//
//  Created by Vinzenz-Emanuel Weber on 05.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import "BMFacebookPost.h"

@implementation BMFacebookPost



- (id)initWithTitle:(NSString *)title descriptionText:(NSString *)description andHref:(NSString *)href {

    if (self = [super init]) {
        
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
}



- (NSMutableDictionary *)params {
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:[jsonWriter stringWithObject:_attachment], @"attachment", nil];
}


@end
