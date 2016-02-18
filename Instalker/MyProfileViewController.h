//
//  MyProfileViewController.h
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView/AsyncImageView.h"
#import "UserLikeTableViewCell.h"


@interface MyProfileViewController : UIViewController<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewStats;

@property (weak,nonatomic) IBOutlet  AsyncImageView *imageViewProfile;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIView *viewContentOfScroll;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *arrayData;

@end
