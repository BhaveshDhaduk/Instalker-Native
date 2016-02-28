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
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)changeDateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMediaCountInInterval;
@property (weak,nonatomic) IBOutlet StatsProfileView *viewStatsProfile;
@property (nonatomic,strong) StatsModel *statsModel;
@property (nonatomic,strong) NSMutableArray *arrayDates;
@end

@implementation StalkProfileViewController

#pragma  mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setDelegates];
    [self configureScrollview];
    
    [self startServiceForBothWithMedia:kAll];
    _arrayDates = [NSMutableArray arrayWithObjects:@"1 Week",@"1 Month",@"3 Months",@"6 Months", @"All Time",nil];
    
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

-(void)startServiceForBothWithMedia:(kMediaDate)date
{
    if (!_user) {
        [self startSelfServicewithDate:date];
        
    }
    else
    {
        
        [self startServiceForUser:_user withDate:date];
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
-(void)startSelfServicewithDate:(kMediaDate)date {
    
    [self startLoadingAnimation];
    
    ServiceManager *manager = [ServiceManager new];
    
    [manager getSelfDataWithCompletion:^(NSMutableArray *likeList, StatsModel *stats) {
        _arrayData = likeList;
        [_viewStatsProfile configureViews:stats];
        [self.viewStatsProfile setNeedsDisplay];
        _statsModel=stats;
        [self.tableView reloadData];
        [self removeLoadingAnimation];
    }failure:^(NSError *error, NSString *errorType) {
        [self removeLoadingAnimation];
    }dateinterval:date];
    
}
-(void)startServiceForUser:(InstagramUser *)user withDate:(kMediaDate)date
{
    [self startLoadingAnimation];
    ServiceManager *manager = [ServiceManager new];
    [manager getDataForUser:user.Id mediaInterval:date withCompletion:^(NSMutableArray *likeList, StatsModel *stats) {
        _arrayData = likeList;
        [_viewStatsProfile configureViews:stats];
        [self.viewStatsProfile setNeedsDisplay];
        _statsModel=stats;
        [self.tableView reloadData];
        [self removeLoadingAnimation];
        
    }withCounting:^(float percentage) {
        
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

#pragma mark - Date Picker
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrayDates.count;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [_arrayDates objectAtIndex:row];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


@end
