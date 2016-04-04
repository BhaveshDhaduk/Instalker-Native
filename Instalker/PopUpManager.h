//
//  PopUpManager.h
//  Instalker
//
//  Created by umut on 23/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLCPopup.h"
#import "LoadingViewController.h"
#import "PopupViewController.h"
#import "UIViewController+CWPopup.h"
#import "ErrorPopupViewController.h"

typedef void (^removalCompletion)(void);
@interface PopUpManager : NSObject <UIGestureRecognizerDelegate>


@property (nonatomic,strong) LoadingViewController *loadingVC;
@property (nonatomic,strong) PopupViewController *popupVC;
@property (nonatomic,strong) UIViewController *hostVC;


+(PopUpManager *)sharedManager;

-(void)showLoadingPopup:(UINavigationController *)navController withCancel:(cancel)cancelBlock;

-(void)showErrorPopupWithTitle:(NSString *)title completion:(removalCompletion)completion from:(UIViewController *)host;

+(void)showSubscriptionPopupWith:(UIViewController *)host;

-(void)removeAllPopups;

-(void)hideLoading;
-(void)hidePopups;
@end
