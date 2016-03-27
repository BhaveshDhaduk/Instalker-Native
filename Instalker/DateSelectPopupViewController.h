//
//  DateSelectPopupViewController.h
//  Instalker
//
//  Created by umut on 3/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  DateSelectPopupViewController;
@protocol DateSelectPopupDelegate <NSObject>
@optional

-(void)dateSelectedWith:(kMediaDate)date;
-(void)selectionCancelled;

@end

@interface DateSelectPopupViewController : UIViewController

@property (nonatomic,weak) id<DateSelectPopupDelegate> delegate;


#pragma mark - IBOUTLETS AND ACTIONS

@property (nonatomic,weak) IBOutlet UIButton *buttonCancel;
@property (nonatomic,weak) IBOutlet UIButton *buttonAllTime;
@property (nonatomic,weak) IBOutlet UIButton *buttonSixMonths;
@property (nonatomic,weak) IBOutlet UIButton *buttonThreeMonths;
@property (nonatomic,weak) IBOutlet UIButton *buttonOneMonth;
@property (nonatomic,weak) IBOutlet UIButton *buttonOneWeek;
- (IBAction)pressedOneWeek:(id)sender;
- (IBAction)pressedOneMonth:(id)sender;
- (IBAction)pressedThreeMonths:(id)sender;
- (IBAction)pressedSixMonths:(id)sender;
- (IBAction)pressedAllTime:(id)sender;
- (IBAction)pressedCancel:(id)sender;

@end
