//
//  BigImageViewController.h
//  Instalker
//
//  Created by umut on 2/29/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BigImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet AsyncImageView *imageViewMain;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeCount;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak,nonatomic) IBOutlet UIButton *buttonClose;
- (IBAction)buttonCloseTapped:(id)sender;
- (IBAction)buttonOpenInstagram:(id)sender;

@property (nonatomic,strong) InstagramMedia *media;

@end
