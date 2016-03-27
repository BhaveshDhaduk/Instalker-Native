//
//  DateSelectPopupViewController.m
//  Instalker
//
//  Created by umut on 3/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "DateSelectPopupViewController.h"

@interface DateSelectPopupViewController ()

@end

@implementation DateSelectPopupViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title =NSLocalizedString(@"Select a date interval", nil);
        self.contentSizeInPopup = CGSizeMake(300, 300);
    }
    return self;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (IBAction)pressedOneWeek:(id)sender {
    [self.popupController dismiss];

    [self.delegate dateSelectedWith:kWeek];
    [self.popupViewController dismissPopupViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedOneMonth:(id)sender {
    [self.popupController dismiss];

    [self.delegate dateSelectedWith:kMonth];
        [self.popupViewController dismissPopupViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedThreeMonths:(id)sender {
    [self.popupController dismiss];

    [self.delegate dateSelectedWith:kThreeMonth];
        [self.popupViewController dismissPopupViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedSixMonths:(id)sender {
    [self.popupController dismiss];

    [self.delegate dateSelectedWith:kSixMonth];
        [self.popupViewController dismissPopupViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedAllTime:(id)sender {
    [self.popupController dismiss];

    [self.delegate dateSelectedWith:kAll];
        [self.popupViewController dismissPopupViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedCancel:(id)sender {
    [self.delegate selectionCancelled];
        [self.popupViewController dismissPopupViewControllerAnimated:YES completion:nil];
    [self.popupController dismiss];
}
@end
