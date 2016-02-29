//
//  PopUpManager.m
//  Instalker
//
//  Created by umut on 23/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "PopUpManager.h"



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

-(void)showLoadingPopup:(UINavigationController *)navController;
{
//    LoadingView *loadingView = [[LoadingView alloc]initWithFrame: CGRectMake(0, 0, 320, 568)];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    LoadingViewController *loadingView = [storyboard instantiateViewControllerWithIdentifier:@"LoadingViewController"];
//    loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
    _loadingVC = loadingView;
    
    [[UIApplication sharedApplication].keyWindow addSubview:loadingView.view];

    
}


-(void)removeAllPopups
{
//    [KLCPopup dismissAllPopups];
    [_loadingVC dismissViewControllerAnimated:YES completion:nil];

}

@end
