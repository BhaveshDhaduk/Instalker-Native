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

typedef void (^removalCompletion)(void);
@interface PopUpManager : NSObject


@property (nonatomic,strong) LoadingViewController *loadingVC;


+(PopUpManager *)sharedManager;

-(void)showLoadingPopup:(UINavigationController *)navController;

-(void)removeAllPopups;


@end
