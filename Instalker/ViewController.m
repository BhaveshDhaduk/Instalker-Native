//
//  ViewController.m
//  Instalker
//
//  Created by umut on 1/23/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "ViewController.h"
#import <InstagramKit/InstagramKit.h>
#import "ServiceManager.h"


@interface ViewController ()

@end


@implementation ViewController
@synthesize webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[InstagramEngine sharedEngine] accessToken] ) {
        [self performSegueWithIdentifier:@"tabSegue" sender:self];

        
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:k_instagram_token])
    {
        [[InstagramEngine sharedEngine] setAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:k_instagram_token]];
        [self performSegueWithIdentifier:@"tabSegue" sender:self];

    }
    
    webview.delegate=self;
    
       // Do any additional setup after loading the view from its nib.

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showWebViewForLogin{
  //  client_id = @"d0bd2df8cd8f4d4e8dc7051a46588303";
  //  secret = @"dd1bcd5422234ee49e9cf32f3a962ca8";
  //  callback = @"http://www.umutafacan.com";
    
    InstagramEngine *engine = [InstagramEngine sharedEngine];
    
    NSURL *authURL = [engine authorizationURL];
    [self.webview loadRequest:[NSURLRequest requestWithURL:authURL]];
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error]) {
        // success!
        
        NSLog(@"Access Token : %@" , [[InstagramEngine sharedEngine] accessToken]);
        
        [Singleton sharedInstance].accessToken = [[InstagramEngine sharedEngine] accessToken];
        [ServiceManager sharedManager].accessToken = [Singleton sharedInstance].accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:[[InstagramEngine sharedEngine] accessToken] forKey:k_instagram_token];

        [self performSegueWithIdentifier:@"tabSegue" sender:self];
    }
    return YES;
}



- (IBAction)buttonPressed:(id)sender {

    [self showWebViewForLogin];
    [UIView animateWithDuration:0.5 animations:^{
        [_viewWelcome setAlpha:0.0];
        
    } completion:^(BOOL finished) {
            [_viewWelcome setHidden:YES];

    }];
    

    
    
}
@end
