//
//  StalkProfileViewController.h
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UserLikeTableViewCell.h"


@interface StalkProfileViewController : UIViewController

#pragma mark - IBOUTLETS

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIView *viewContentOfScroll;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *labelNameForTitle;

#pragma mark - Properties
@property (strong,nonatomic) NSMutableArray *arrayData;

@property (strong,nonatomic) InstagramUser *user;


@end
