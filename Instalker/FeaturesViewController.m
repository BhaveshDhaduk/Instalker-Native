//
//  FeaturesViewController.m
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "FeaturesViewController.h"
#import "AgreementViewController.h"
#import "InAppViewController.h"
#import <STPopup/STPopup.h>

@interface FeaturesViewController ()
- (IBAction)buyWeekly:(id)sender;

@end

@implementation FeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"Settings";
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Settings"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [super viewDidAppear:animated];
    self.navigationItem.title =NSLocalizedString( @"Settings",nil);
    self.navigationItem.titleView.tintColor =  [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"agreement"]) {
        AgreementViewController *vc =(AgreementViewController *)segue.destinationViewController;
        vc.hidesBottomBarWhenPushed=YES;
    }
    
}


- (IBAction)clearSearchHistory:(id)sender {
    [Singleton sharedInstance].arraySearchHistory = [NSMutableArray array];
    NSData *data = [NSKeyedArchiver  archivedDataWithRootObject:[NSArray arrayWithArray:[Singleton sharedInstance].arraySearchHistory]];
    [[NSUserDefaults standardUserDefaults]setObject:data  forKey:k_Search_History_List];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Search history is cleaned!",nil) level:kRZErrorMessengerLevelPositive];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [RZErrorMessenger hideAllErrors];
    });
    
}


- (IBAction)logout:(id)sender {
    [[InstagramEngine sharedEngine]logout];
    [[Singleton sharedInstance].baseNavigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)buyWeekly:(id)sender {
    [self showSubscriptionPopupWith:self];
}

-(void)showSubscriptionPopupWith:(UIViewController *)host
{
    InAppViewController *vc = [[InAppViewController alloc]initWithNibName:@"InAppViewController" bundle:nil];
    vc.view.frame = CGRectMake(0, 0, 300, 350);
    vc.contentSizeInPopup=CGSizeMake(300, 350);
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    if (NSClassFromString(@"UIBlurEffect")) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    
    [STPopupNavigationBar appearance].barTintColor = k_color_navy;
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:18], NSForegroundColorAttributeName: [UIColor whiteColor] };
    [STPopupNavigationBar appearance].layer.cornerRadius = 5.0;

    popupController.backgroundView.backgroundColor=[UIColor clearColor];
    popupController.containerView.backgroundColor=[UIColor clearColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[STPopupNavigationBar class], nil] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Cochin" size:17] } forState:UIControlStateNormal];
    popupController.style = STPopupStyleFormSheet;
    [popupController presentInViewController:host];
}
@end
