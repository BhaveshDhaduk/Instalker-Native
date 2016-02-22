//
//  StalkListViewController.h
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"
@interface StalkListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


#pragma  mark - Variables

@property (nonatomic,strong) NSMutableArray *arraySearchList;

@end
