//
//  BMViewController.m
//  ShareExample
//
//  Created by Vinzenz-Emanuel Weber on 05.11.11.
//  Copyright (c) 2011 Blockhaus Medienagentur. All rights reserved.
//

#import "BMViewController.h"


@implementation BMViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (IBAction)facebookButtonClicked:(id)sender {
    
    
#if 0
    BMFacebookPost *post = [[BMFacebookPost alloc] initWithTitle:@"Simple sharing via Facebook, Email and Twitter for iOS!" 
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
#else
    
    
    BMFacebookPost *post = [[BMFacebookPost alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
    
    
#endif
    
    [[BMSocialShare sharedInstance] facebookPublish:post];
    
}


- (IBAction)emailButtonClicked:(id)sender {

    NSString *storePath = [[NSBundle mainBundle] pathForResource:@"blockhaus" ofType:@"png"];

    [[BMSocialShare sharedInstance] emailPublishText:@"Posting to Facebook, Twitter and Email made dead simple on iOS. Simply include BMSocialShare as a framework and you are ready to go.\nhttp://github.com/blockhaus/BMSocialShare"
                                         withSubject:@"Simple sharing with BMSocialShare"
                                           withImage:storePath 
                              inParentViewController:self];
    
}


- (IBAction)twitterButtonClicked:(id)sender {
    
    [[BMSocialShare sharedInstance] twitterPublishText:@"Posting to Facebook, Twitter and Email made dead simple on iOS with BMSocialShare"
                                             withImage:nil
                                                andURL:[NSURL URLWithString:@"http://github.com/blockhaus/BMSocialShare"]
                                inParentViewController:self]; 

}


@end
