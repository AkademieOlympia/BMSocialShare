//
//  BMDialog.m
//  mag-engine
//
//  Created by Vinzenz-Emanuel Weber on 08.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur OG. All rights reserved.
//

#import "BMDialog.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};

static CGFloat kTransitionDuration = 0.3;

static CGFloat kPadding = 0;
static CGFloat kBorderWidth = 10;

///////////////////////////////////////////////////////////////////////////////////////////////////

static BOOL FBIsDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation BMDialog

@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    
    if (radius == 0) {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddRect(context, rect);
    } else {
        rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
        CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    }
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    if (fillColors) {
        CGContextSaveGState(context);
        CGContextSetFillColor(context, fillColors);
        if (radius) {
            [self addRoundedRectToPath:context rect:rect radius:radius];
            CGContextFillPath(context);
        } else {
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    
    CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorSpace(context, space);
    CGContextSetStrokeColor(context, strokeColor);
    CGContextSetLineWidth(context, 1.0);
    
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y-0.5},
            {rect.origin.x+rect.size.width, rect.origin.y-0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5},
            {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+rect.size.width-0.5, rect.origin.y},
            {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
            {rect.origin.x+0.5, rect.origin.y+rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(space);
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == _orientation) {
        return NO;
    } else {
        return orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown
        || orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight;
    }
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scale_factor = 1.0f;
    if (FBIsDeviceIPad()) {
        // On the iPad the dialog's dimensions should only be 60% of the screen's
        scale_factor = 0.6f;
    }
    
    CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
    CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (void)updateOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        /*
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.setAttribute('orientation', 90);"];
         */
    } else {
        /*
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.removeAttribute('orientation');"];
         */
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}


- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)postDismissCleanup {
    [self removeObservers];
    [self removeFromSuperview];
    [_modalBackgroundView removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {

    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}

- (void)cancel {
    [self dialogDidCancel:nil];
}


- (void)post {
    
    _closeButton.enabled = FALSE;
    _okButton.enabled = FALSE;
    _cancelButton.enabled = FALSE;
    _textField.enabled = FALSE;
    _spinner.hidden = FALSE;
    [_spinner startAnimating];
    
    if (_textField.text) {
        [_post setImageName:_textField.text];
    }
    
    [_facebook requestWithGraphPath:@"me/photos"
                          andParams:_post.params
                      andHttpMethod:@"POST"
                        andDelegate:self];

}

////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate


/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 * didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    NSString *photoId = [result objectForKey:@"id"];
    if (photoId) {
        NSLog(@"Uploaded Photo with ID: %@", photoId);        
        [self dialogDidSucceed:nil];
        return;
    }
    
    [self dialogDidCancel:nil];
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", [error localizedDescription]);
    [self dialogDidCancel:nil];
};



///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
    if ((self = [super initWithFrame:CGRectZero])) {
        _delegate = nil;
        _showingKeyboard = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 480, 480)];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        
        UIImageView *toolbarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 45)];
        toolbarImageView.image = [UIImage imageNamed:@"BMSocialShare.bundle/facebook_toolbar_background.png"];
        toolbarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        toolbarImageView.contentMode = UIViewContentModeScaleToFill;
        [_containerView addSubview:toolbarImageView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 480, 21)];
        label.textAlignment = UITextAlignmentCenter;
        label.text = @"Facebook";
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, -1);
        label.shadowColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_containerView addSubview:label];
        
 
        _textField =[[UITextField alloc] initWithFrame:CGRectMake(20, 55, 440, 50)];
        _textField.placeholder = @"Comment ...";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [textField addTarget:self action:@selector(post) forControlEvents:UIControlEvent]
        [_containerView addSubview:_textField];

        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 115, _containerView.frame.size.width - 40, _containerView.frame.size.height - 125)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_containerView addSubview:_imageView];
                

        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"BMSocialShare.bundle/facebook_button_background.png"];
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, buttonBackgroundImage.size.width, buttonBackgroundImage.size.height)];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel)
               forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _cancelButton.titleLabel.textColor = [UIColor whiteColor];
        _cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        _cancelButton.titleLabel.shadowColor = [UIColor blackColor];
        [_containerView addSubview:_cancelButton];
        
        _okButton = [[UIButton alloc] initWithFrame:CGRectMake(_containerView.frame.size.width - buttonBackgroundImage.size.width - 10, 10, buttonBackgroundImage.size.width, buttonBackgroundImage.size.height)];
        [_okButton setTitle:@"Share" forState:UIControlStateNormal];
        _okButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_okButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _okButton.titleLabel.textColor = [UIColor whiteColor];
        _okButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        _okButton.titleLabel.shadowColor = [UIColor blackColor];
        [_okButton addTarget:self action:@selector(post)
               forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_okButton];
        
        UIImage* closeImage = [UIImage imageNamed:@"FBDialog.bundle/images/close.png"];
        
        UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
        _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton setTitleColor:color forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(cancel)
               forControlEvents:UIControlEventTouchUpInside];
        
        // To be compatible with OS 2.x
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_2_2
        _closeButton.font = [UIFont boldSystemFontOfSize:12];
#else
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
#endif
        
        _closeButton.showsTouchWhenHighlighted = YES;
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_closeButton];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                    UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_spinner];
/*
        [_spinner stopAnimating];
        _spinner.hidden = YES;
*/
        _modalBackgroundView = [[UIView alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_containerView release];
    [_post release];
    [_spinner release];
    [_closeButton release];
    [_modalBackgroundView release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
    [self drawRect:rect fill:kBorderGray radius:0];
    
    CGRect webRect = CGRectMake(
                                ceil(rect.origin.x + kBorderWidth), ceil(rect.origin.y + kBorderWidth)+1,
                                rect.size.width - kBorderWidth*2, _containerView.frame.size.height+1);
    
    [self strokeLines:webRect stroke:kBorderBlack];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (!_showingKeyboard && [self shouldRotateToOrientation:orientation]) {
        [self updateOrientation];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification {
    
    _showingKeyboard = YES;
    
    if (FBIsDeviceIPad()) {
        // On the iPad the screen is large enough that we don't need to
        // resize the dialog to accomodate the keyboard popping up
        return;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _containerView.frame = CGRectInset(_containerView.frame,
                                     -(kPadding + kBorderWidth),
                                     -(kPadding + kBorderWidth));
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _showingKeyboard = NO;
    
    if (FBIsDeviceIPad()) {
        return;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _containerView.frame = CGRectInset(_containerView.frame,
                                     kPadding + kBorderWidth,
                                     kPadding + kBorderWidth);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// public


- (id)initWithFacebook:(Facebook *)facebook
                  post:(BMFacebookPost *)post
              delegate:(id <BMDialogDelegate>) delegate {

    self = [self init];
    _post = [post retain];
    _delegate = delegate;
    _facebook = facebook;

    _imageView.image = _post.image;
    
    return self;
}

- (void)show {
    [self sizeToFitOrientation:NO];
    
    CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;
    [_closeButton sizeToFit];
    
    _closeButton.frame = CGRectMake(
                                    2,
                                    2,
                                    29,
                                    29);
    
    _containerView.frame = CGRectMake(
                                kBorderWidth+1,
                                kBorderWidth+1,
                                innerWidth,
                                self.frame.size.height - (1 + kBorderWidth*2));
    
    [_spinner sizeToFit];
    _spinner.center = _containerView.center;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    _modalBackgroundView.frame = window.frame;
    [_modalBackgroundView addSubview:self];
    [window addSubview:_modalBackgroundView];
    
    [window addSubview:self];
        
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
    [self addObservers];
}

- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated {
    if (success) {
        if ([_delegate respondsToSelector:@selector(dialogDidComplete:)]) {
            [_delegate dialogDidComplete:self];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(dialogDidNotComplete:)]) {
            [_delegate dialogDidNotComplete:self];
        }
    }
    
    [self dismiss:animated];
}

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(dialog:didFailWithError:)]) {
        [_delegate dialog:self didFailWithError:error];
    }
    
    [self dismiss:animated];
}


- (void)dialogDidSucceed:(NSURL *)url {
/*
    if ([_delegate respondsToSelector:@selector(dialogCompleteWithUrl:)]) {
        [_delegate dialogCompleteWithUrl:url];
    }
*/
    [self dismissWithSuccess:YES animated:YES];
}

- (void)dialogDidCancel:(NSURL *)url {
/*
    if ([_delegate respondsToSelector:@selector(dialogDidNotCompleteWithUrl:)]) {
        [_delegate dialogDidNotCompleteWithUrl:url];
    }
*/
    [self dismissWithSuccess:NO animated:YES];
}

@end
