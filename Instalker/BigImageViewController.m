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
    _labelDate.text = _media.createdDate.description;
    _labelLikeCount.text = [NSString stringWithFormat:@"%ld likes",_media.likesCount];
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

- (IBAction)buttonCloseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)buttonOpenInstagram:(id)sender {
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:_media.link]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_media.link]];
    }
    
}
@end
