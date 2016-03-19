//
//  AgreementViewController.m
//  Instalker
//
//  Created by umut on 13/03/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationProperties];
    self.navigationItem.title = @"User Agreement";
    // Do any additional setup after loading the view.
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureNavigationProperties
{
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.backItem.titleView.tintColor= [UIColor whiteColor];
    self.navigationController.navigationBar.backItem.title = @"Back";
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
