//
//  MyProfileViewController.m
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ServiceManager.h"
#import "StatsProfileView.h"
#import "MediaViewController.h"


@interface MyProfileViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)changeDateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMediaCountInInterval;
@property (weak,nonatomic) IBOutlet StatsProfileView *viewStatsProfile;
@property (nonatomic,strong) StatsModel *statsModel;
@property (nonatomic,strong) NSMutableArray *arrayDates;
@property (nonatomic) BOOL isDataObtained;
@end

@implementation MyProfileViewController

#pragma  mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setDelegates];
    [self configureScrollview];
   
    _arrayDates = [NSMutableArray arrayWithObjects:@"1 Week",@"1 Month",@"3 Months",@"6 Months", @"All Time",nil];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_isDataObtained) {
     [self startServiceForBothWithMedia:kAll];
        _isDataObtained = YES;
    }
    
    if (!_user ) {
     [self configureNavigationBarForMyProfile];
    }else
    {
        [self configureNavigationBarWithTitle:_user.username];
    
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PopUpManager sharedManager] removeAllPopups];

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
-(void)startSelfServicewithDate:(kMediaDate)date {
    
    [self startLoadingAnimation];
    
    ServiceManager *manager = [ServiceManager new];
    
    [manager getSelfDataWithCompletion:^(NSMutableArray *likeList, StatsModel *stats) {
        _arrayData = likeList;
        [self.tableView reloadData];
        _statsModel=stats;
        [_viewStatsProfile configureViews:stats];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeLoadingAnimation];
        });

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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeLoadingAnimation];
        });

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
        
        MyProfileViewController *destinationViewController = segue.destinationViewController;
        UserLikeTableViewCell *cell = (UserLikeTableViewCell *)sender;
        destinationViewController.user = cell.user;
    }
    if ([segue.identifier isEqualToString:@"showMedia"]) {
        MediaViewController *mediaVC = segue.destinationViewController;
        UserLikeTableViewCell *cell = (UserLikeTableViewCell *)[[sender superview]superview];
        mediaVC.arrayLikedMedias =cell.arrayLikedMedias;

    }
}

-(void)configurePickerViewHidden:(BOOL)hidden
{
    if(hidden)
    {
        [UIView animateWithDuration:0.4 animations:^{
            _pickerView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            _pickerView.hidden=hidden;
        }];
    }else
    {
        _pickerView.hidden = hidden;
        [UIView animateWithDuration:0.3 animations:^{
            _pickerView.transform = CGAffineTransformMakeTranslation(0, -300);
        } completion:^(BOOL finished) {
            
        }];
    
    }

}

- (IBAction)changeDateButtonPressed:(id)sender {
    if (_pickerView.hidden) {
        [self configurePickerViewHidden:NO];
        [_buttonChangeDate setTitle:@"Select Date and Tap Here" forState:UIControlStateNormal];
    }else
    {
        switch ([_pickerView selectedRowInComponent:0]) {
            case 0:
                [self startServiceForBothWithMedia:kWeek];
                break;
                
            case 1:
                [self startServiceForBothWithMedia:kMonth];
                break;
            case 2:
                [self startServiceForBothWithMedia:kThreeMonth];
                break;
            case 3:
                [self startServiceForBothWithMedia:kSixMonth];
                break;
            case 4:
                [self startServiceForBothWithMedia:kAll];
                break;
            default:
                [self startServiceForBothWithMedia:kAll];
                break;
        }
        [self configurePickerViewHidden:YES];
        [_buttonChangeDate setTitle:[_arrayDates objectAtIndex:[_pickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
        
    }
    
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
