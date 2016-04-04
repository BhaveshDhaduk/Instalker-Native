//
//  InAppViewController.h
//  Instalker
//
//  Created by umut on 3/27/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelPriceForAWeek;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceForAMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceForAThreeMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelWeek;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelThreeMonth;
@property (weak, nonatomic) IBOutlet UIView *viewWeek;
@property (weak, nonatomic) IBOutlet UIView *viewMonth;
@property (weak, nonatomic) IBOutlet UIView *viewThreeMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeLeft;
@property (weak, nonatomic) IBOutlet UIView *viewTimer;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeLeftTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubType;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;

@end
