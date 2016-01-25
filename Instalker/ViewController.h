//
//  ViewController.h
//  Instalker
//
//  Created by umut on 1/23/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface ViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (weak, nonatomic) IBOutlet UIButton *buttonSignin;
- (IBAction)buttonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewWelcome;

@end

