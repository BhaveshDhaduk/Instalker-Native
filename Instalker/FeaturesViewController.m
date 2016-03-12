//
//  FeaturesViewController.m
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "FeaturesViewController.h"

@interface FeaturesViewController ()

@end

@implementation FeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"SETTINGS";
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"SETTINGS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clearSearchHistory:(id)sender {
    [Singleton sharedInstance].arraySearchHistory = [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:[Singleton sharedInstance].arraySearchHistory forKey:k_Search_History_List];
    
}

- (IBAction)showPrivacyPolicy:(id)sender {
    
    
}
- (IBAction)logout:(id)sender {
    [[InstagramEngine sharedEngine]logout];
    [[Singleton sharedInstance].baseNavigationController popToRootViewControllerAnimated:YES];
    
}
@end
