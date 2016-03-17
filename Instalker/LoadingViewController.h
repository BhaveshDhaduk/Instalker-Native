//
//  LoadingViewController.h
//  Instalker
//
//  Created by umut on 23/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController

- (IBAction)buttonCancelTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOuterView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewInnerEye;
@property (weak, nonatomic) IBOutlet UILabel *labelStalking;
@property (weak, nonatomic) IBOutlet UILabel *labelPercentage;

@property (nonatomic,strong) cancel cancelBlock;

@end
