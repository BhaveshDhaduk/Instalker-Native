//
//  MyProfileViewController.m
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ServiceManager.h"


@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollViewMain.delegate=self;
    
    _scrollViewMain.contentSize=CGSizeMake(_viewContentOfScroll.bounds.size.width, _viewContentOfScroll.bounds.size.height);
    _tableView.delegate= self;
    _tableView.dataSource=self;
    
    
    
    
    [ServiceManager sharedManager].accessToken = [Singleton sharedInstance].accessToken;
    
    
    [[ServiceManager sharedManager] getMediasWithCompletion:^(NSMutableArray *result) {
        _arrayData=result;
        [_tableView reloadData];
    }];
    
    
    
    // Do any additional setup after loading the view.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userLikeCell" forIndexPath:indexPath];
    [cell setFields:[_arrayData objectAtIndex:indexPath.row]];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _arrayData.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
