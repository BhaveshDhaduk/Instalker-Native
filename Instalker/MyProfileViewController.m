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
@property (weak,nonatomic) IBOutlet UIButton *buttonPickerButton;
@property (weak,nonatomic) IBOutlet UIView *viewPickerContainer;
@property (weak,nonatomic) IBOutlet UILabel *labelNoMediaWarning;
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
        [self startServiceForBothWithMedia:kWeek];
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
    [self configureNavigationProperties];
}

-(void)configureNavigationBarWithTitle:(NSString *)title
{
    self.navigationItem.title = title;
    [self configureNavigationProperties];
}


-(void)configureNavigationProperties
{
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
 
    self.navigationController.navigationBar.backItem.titleView.tintColor= [UIColor whiteColor];
    self.navigationController.navigationBar.backItem.title = @"Back";
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            _arrayData = likeList;
            [self.tableView reloadData];
            _statsModel=stats;
            [_viewStatsProfile configureViews:stats];
            _labelNameForTitle.text = stats.textName;
            if (stats.filteredPostCount <1) {
                [_labelNoMediaWarning setHidden:NO];
            }
            else
            {
                [_labelNoMediaWarning setHidden:YES];
            }
            _labelMediaCountInInterval.text= [NSString stringWithFormat:@"%ld Media",(long)stats.filteredPostCount];
            [self removeLoadingAnimation];
          
            
        });
        
    }failure:^(NSError *error, InstagramFailModel *errorModel) {
        
        [self removeLoadingAnimation];
        [self showError:errorModel];
    }dateinterval:date];
    
}
-(void)showError:(InstagramFailModel *)model
{
    if ([model.meta.errorType isEqualToString:k_error_null_token_count]) {
        [[PopUpManager sharedManager] showErrorPopupWithTitle:@"Your daily Instagram token limit is accessed, Try to use tomorrow" completion:^{
            [[Singleton sharedInstance].baseNavigationController popToRootViewControllerAnimated:YES];
        }];
        
        
    }else
     if ([model.meta.errorType isEqualToString:k_error_private_profile]) {
         [[PopUpManager sharedManager]showErrorPopupWithTitle:@"This profile is private, try to stalk others" completion:^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
             
         }];
         
     
     }else if ([model.meta.errorType isEqualToString:k_error_token_invalid]) {
         [[PopUpManager sharedManager] showErrorPopupWithTitle:@"Your Instagram credentials invalidated by Instagram, try to login again" completion:^{
             [[InstagramEngine sharedEngine]logout];
             [[Singleton sharedInstance].baseNavigationController popToRootViewControllerAnimated:YES];
         }];
         
         
     }
    else
    {
        [[PopUpManager sharedManager]showErrorPopupWithTitle:model.meta.errorMessage completion:^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }];
    
    
    }

}


-(void)startServiceForUser:(InstagramUser *)user withDate:(kMediaDate)date
{
    [self startLoadingAnimation];
    ServiceManager *manager = [ServiceManager new];
    [manager getDataForUser:user.Id mediaInterval:date withCompletion:^(NSMutableArray *likeList, StatsModel *stats) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _arrayData = likeList;
            [_viewStatsProfile configureViews:stats];
            [self.viewStatsProfile setNeedsDisplay];
            _statsModel=stats;
            [self.tableView reloadData];
            _labelNameForTitle.text = stats.textName;
            _labelMediaCountInInterval.text= [NSString stringWithFormat:@"%ld Media",(long)stats.filteredPostCount];
            [self removeLoadingAnimation];
            
        });
        
    }withCounting:^(float percentage) {
        
    } failure:^(NSError *error, InstagramFailModel *errorModel) {
        [self removeLoadingAnimation];
         [self showError:errorModel];
    }];
    
    
}


#pragma mark - Animations

-(void)startLoadingAnimation
{
    [[PopUpManager sharedManager]showLoadingPopup:self.navigationController withCancel:^{
        [self.navigationController popViewControllerAnimated:NO];
        [[PopUpManager sharedManager]removeAllPopups];
    }];
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
            _viewPickerContainer.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            _viewPickerContainer.hidden=hidden;
        }];
    }else
    {
        _viewPickerContainer.hidden = hidden;
        [UIView animateWithDuration:0.3 animations:^{
            _viewPickerContainer.transform = CGAffineTransformMakeTranslation(0, -300);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (IBAction)changeDateButtonPressed:(id)sender {
    if (_viewPickerContainer.hidden) {
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
