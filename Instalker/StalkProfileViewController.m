//
//  StalkProfileViewController.m
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "StalkProfileViewController.h"
#import "ServiceManager.h"
#import "StatsProfileView.h"


@interface StalkProfileViewController ()
- (IBAction)changeDateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMediaCountInInterval;
@property (weak,nonatomic) IBOutlet StatsProfileView *viewStatsProfile;
@property (nonatomic,strong) StatsModel *statsModel;
@end

@implementation StalkProfileViewController

#pragma  mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setDelegates];
    [self configureScrollview];
    if (!_user) {

    }
    else
    {
        
        [self startServiceForUser:_user];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_user ) {
        [self configureNavigationBarForMyProfile];
    }else
    {
        [self configureNavigationBarWithTitle:_user.username];
        
    }
    
}

#pragma mark - Navigation Bar
-(void)configureNavigationBarForMyProfile
{
    self.navigationItem.title = @"MY PROFILE";
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
}

-(void)configureNavigationBarWithTitle:(NSString *)title
{
    self.navigationItem.title = title;
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
}


#pragma mark - Initilization
-(void)configureScrollview{
    _scrollViewMain.contentSize=CGSizeMake(_viewContentOfScroll.bounds.size.width, _viewContentOfScroll.bounds.size.height);
}
-(void)setDelegates
{
    _scrollViewMain.delegate=self;
    _tableView.delegate= self;
    _tableView.dataSource=self;
}
-(void)startSelfService{
    
    [self startLoadingAnimation];
    [[ServiceManager sharedManager] getSelfDataWithCompletion:^(NSMutableArray *likeList, StatsModel *stats) {
        _arrayData = likeList;
        [_viewStatsProfile configureViews:stats];
        [self.viewStatsProfile setNeedsDisplay];
        _statsModel=stats;
        [self.tableView reloadData];
        [self removeLoadingAnimation];
    }failure:^(NSError *error, NSString *errorType) {
        [self removeLoadingAnimation];
    }];
    
}
-(void)startServiceForUser:(InstagramUser *)user
{
    [self startLoadingAnimation];
    
    [[ServiceManager sharedManager] getDataForUser:user.Id withCompletion:^(NSMutableArray *likeList, StatsModel *stats) {
        _arrayData = likeList;
        [_viewStatsProfile configureViews:stats];
        [self.viewStatsProfile setNeedsDisplay];
        _statsModel=stats;
        [self.tableView reloadData];
        [self removeLoadingAnimation];
        
    }];
    
    
}


#pragma mark - Animations

-(void)startLoadingAnimation
{
    [[PopUpManager sharedManager]showLoadingPopup];
}

-(void)removeLoadingAnimation
{
    [[PopUpManager sharedManager]removeAllPopups];
    
}

#pragma mark - TableView Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userLikeCell" forIndexPath:indexPath];
    [cell setFields:[_arrayData objectAtIndex:indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"stalkMyFollower"]) {
        
        StalkProfileViewController *destinationViewController = segue.destinationViewController;
        UserLikeTableViewCell *cell = (UserLikeTableViewCell *)sender;
        destinationViewController.user = cell.user;
    }
    if ([segue.identifier isEqualToString:@"stalkFollower"]) {
        StalkProfileViewController *destinationViewController = segue.destinationViewController;
        UserLikeTableViewCell *cell = (UserLikeTableViewCell *)sender;
        destinationViewController.user = cell.user;
    }
    
}


- (IBAction)changeDateButtonPressed:(id)sender {
    
    
}

@end
