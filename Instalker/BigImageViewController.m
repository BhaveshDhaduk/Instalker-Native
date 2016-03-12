//
//  BigImageViewController.m
//  Instalker
//
//  Created by umut on 2/29/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController ()

@end

@implementation BigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _imageViewMain.imageURL = _media.standardResolutionImageURL;
    _labelDate.text = [self relativeDateStringForDate:_media.createdDate];
    _labelLikeCount.text = [NSString stringWithFormat:@"%ld likes",(long)_media.likesCount];
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

- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}

- (IBAction)buttonCloseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)buttonOpenInstagram:(id)sender {
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:_media.link]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_media.link]];
    }
    
}
@end
