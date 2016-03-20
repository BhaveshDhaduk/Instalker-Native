//
//  PopUpManager.m
//  Instalker
//
//  Created by umut on 23/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "PopUpManager.h"
#import "ErrorPopupViewController.h"
typedef void (^completionPopup)(void);


@implementation PopUpManager

#pragma mark - Initialization Methods
+(PopUpManager *)sharedManager
{
    static PopUpManager *_sharedManager  = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        _sharedManager = [[PopUpManager alloc]init];
    });
    return _sharedManager;
}

-(id)init{
    if (self) {
        
    }
    return self;
}


#pragma mark - Popup Methods

-(void)showLoadingPopup:(UINavigationController *)navController withCancel:(cancel)cancelBlock;
{
//    LoadingView *loadingView = [[LoadingView alloc]initWithFrame: CGRectMake(0, 0, 320, 568)];
    if (_loadingVC) {
        _loadingVC = nil;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    LoadingViewController *loadingView = [storyboard instantiateViewControllerWithIdentifier:@"LoadingViewController"];
//    loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
//    KLCPopup *popup = [KLCPopup popupWithContentView:loadingView.view showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeClear dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    
//    popup.userInteractionEnabled=NO;
//    [popup show];
    loadingView.cancelBlock=cancelBlock;
   
    
    _loadingVC = loadingView;
    
    
    [navController presentViewController:loadingView animated:YES completion:^{
        
    }];

}

-(void)showErrorPopupWithTitle:(NSString *)title completion:(removalCompletion)completion from:(UIViewController *)host
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    PopupViewController *loadingView = [storyboard instantiateViewControllerWithIdentifier:@"PopupViewController"];
    loadingView.view.frame = CGRectMake(0, 0, 300, 300);
    loadingView.labelPopupText.text = title;
    _popupVC = loadingView;
    _hostVC = host;
    host.useBlurForPopup = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopups)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [host.view addGestureRecognizer:tapRecognizer];
    [host presentPopupViewController:loadingView animated:YES completion:^{
        
    }];
    
    
}


-(void)removeAllPopups
{
    if (_loadingVC) {
        [_loadingVC dismissViewControllerAnimated:YES completion:^{
            _loadingVC = nil;
        }];
    }
    if (_hostVC && _hostVC.popupViewController ) {
        [_hostVC dismissPopupViewControllerAnimated:YES
                                         completion:^{
                                             [_hostVC popupViewController];
                                             
                                             
                                         }];
    }


}

-(void)hideLoading
{
    if (_loadingVC) {
        [_loadingVC dismissViewControllerAnimated:YES completion:^{
            _loadingVC = nil;
        }];
    }
    
}

-(void)hidePopups
{
    if (_hostVC && _hostVC.popupViewController ) {
        [_hostVC dismissPopupViewControllerAnimated:YES
                                         completion:^{
                                             [_hostVC popupViewController];
                                             
                                            
                                         }];
    }

}
#pragma mark - gesture recognizer delegate functions

// so that tapping popup view doesnt dismiss it


@end
