//
//  InAppViewController.m
//  Instalker
//
//  Created by umut on 3/27/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "InAppViewController.h"
#import <RMStore/RMStore.h>
#import "RMStoreKeychainPersistence.h"
#import "RMAppReceipt.h"
#import <BALoadingView/BALoadingView.h>
#import <RMStore/RMStoreAppReceiptVerificator.h>



@interface InAppViewController ()
- (IBAction)buyForAWeek:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buyForAMonth;
@property (weak, nonatomic) IBOutlet UIButton *buyForThreeMonth;
@property (weak, nonatomic) IBOutlet UIButton *buttonBuyForAWeek;
- (IBAction)actionRestorePurchases:(id)sender;
- (IBAction)buyForThreeMonth:(id)sender;
- (IBAction)buyForAMonth:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (nonatomic,strong) BALoadingView *loadingView;
@property (nonatomic,strong) RMStoreAppReceiptVerificator *receiptVerificator;

@end
#define k_subscription_Weekly @"com.mhs.instalker.premium.week"
#define k_subscription_Monthly @"com.mhs.instalker.premium.1month"
#define k_subscription_3Monthly @"com.mhs.instalker.premium.3month"
#define k_subscription_base @"com.mhs.instalker.premium"


@implementation InAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeInPopup = CGSizeMake(300, 400);
    self.title=NSLocalizedString(@"Premium Subscription", nil);
    if ([InAppHelper isSubscriptionAvailable]) {
        [self configureAsSubscribed];
    }
    else
    {
        [self getPrices];
    }

    _receiptVerificator = [[RMStoreAppReceiptVerificator alloc]init];
    _receiptVerificator.bundleIdentifier = @"net.sparkson.instalker";
    _receiptVerificator.bundleVersion = @"1.0";
  
    
}

-(void)configureAsLoading:(BOOL)loading
{
    _viewLoading.hidden=!loading;
    if (loading) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.loadingView = [[BALoadingView alloc] initWithFrame:self.viewLoading.frame];
        [self.loadingView initialize];
        self.loadingView.clockwise = YES;
        self.loadingView.segmentColor = k_color_navy;
        [self.loadingView startAnimation:BACircleAnimationFullCircle];
        [self.view addSubview:self.loadingView];
    }else
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self.loadingView stopAnimation];
        [self.loadingView removeFromSuperview];
    }
    
}


-(void)getPrices
{

    _labelMessage.text = NSLocalizedString(@"To use all premium features, do not hesitate to subscribe", nil);
    NSSet *products = [NSSet setWithArray:@[k_subscription_Weekly,k_subscription_Monthly,k_subscription_3Monthly]];
    [self configureAsLoading:YES];
    if ([RMStore  canMakePayments]) {
        [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
           
                [self configureLocalizedPriceLabels:products];
         
            [self configureAsLoading:NO];
            NSLog(@"Products loaded");
        } failure:^(NSError *error) {
            NSLog(@"Something went wrong");
            [self configureAsLoading:NO];
        }];
    }


}
-(void)restorePurchase
{
    RMStoreKeychainPersistence *persistence = [RMStore defaultStore].transactionPersistor;
    [persistence removeTransactions];
    
    // Your code
    [self configureAsLoading:YES];
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
        NSLog(@"Transactions restored");
        [[RMStore defaultStore] refreshReceiptOnSuccess:^{
            NSLog(@"Receipt refreshed");
            if ([_receiptVerificator verifyAppReceipt]) {
                
            }else
            {
                
            }
            if ([InAppHelper isSubscriptionAvailable]) {
                [self configureAsSubscribed];
            }
            [self configureAsLoading:NO];
            
        } failure:^(NSError *error) {
            NSLog(@"Something went wrong");
            [self configureAsLoading:NO];
            
        }];
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
        [self configureAsLoading:NO];
    }];
}


-(NSDateComponents *)dateTrimmer:(NSDate *)expireDate
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss ZZZ"];
    NSDate *startDate = [NSDate date];
    NSDate *endDate = expireDate;
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute)
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return components;
    
}
-(void)configureAsSubscribed
{
    self.labelMessage.text = NSLocalizedString(@"Enjoy your premium subscription!", nil);
    [self setTimeLeftLabel];
    _viewTimer.hidden = NO;

}

-(void)setTimeLeftLabel
{
    NSDateComponents *component = [self dateTrimmer:[InAppHelper dateOfExpireForSubscription]];
    if (component.month>0) {
        _labelTimeLeft.text = [NSString stringWithFormat:NSLocalizedString(@"%d Months, %d Days, %d Hours Left", nil),component.month,component.day,component.hour];
    }else if(component.day>0)
    {
        _labelTimeLeft.text = [NSString stringWithFormat:NSLocalizedString(@"%d Days, %d Hours Left", nil),component.day,component.hour];
    
    }else if(component.hour>0){
        _labelTimeLeft.text = [NSString stringWithFormat:NSLocalizedString(@"%d Hours Left", nil),component.hour];
    }else
    {
        _labelTimeLeft.text = [NSString stringWithFormat:NSLocalizedString(@"%d Minutes Left", nil),component.minute];

    }


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Price Methods
-(NSString *)localizedPriceOfProduct:(SKProduct *)product
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *price = [numberFormatter stringFromNumber:product.price];
    return price;
}
-(void)configureLocalizedPriceLabels:(NSArray *)products
{
    SKProduct *weeklyProduct = [products objectAtIndex:2];
    _labelPriceForAWeek.text=[self localizedPriceOfProduct:weeklyProduct];
    SKProduct *monthlyProduct = [products objectAtIndex:0];
    _labelPriceForAMonth.text=[self localizedPriceOfProduct:monthlyProduct];
    SKProduct *ThreeMonthProduct = [products objectAtIndex:1];
    _labelPriceForAThreeMonth.text= [self localizedPriceOfProduct:ThreeMonthProduct];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - Buy Actions
- (IBAction)buyForAWeek:(id)sender {
    
    [self configureAsLoading:YES];
    [[RMStore defaultStore] addPayment:k_subscription_Weekly success:^(SKPaymentTransaction *transaction) {
       
            [self configureAsSubscribed];
            [self configureAsLoading:NO];
            [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Payment successfull!",nil) level:kRZErrorMessengerLevelPositive];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [RZErrorMessenger hideAllErrors];
            });
                
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [self configureAsLoading:NO];
        [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Payment could not completed!",nil) level:kRZErrorMessengerLevelError];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [RZErrorMessenger hideAllErrors];
        });

        
    }];
}
- (IBAction)actionRestorePurchases:(id)sender {
    [self restorePurchase];
    
}

- (IBAction)buyForThreeMonth:(id)sender {
        [self configureAsLoading:YES];
    [[RMStore defaultStore] addPayment:k_subscription_Weekly success:^(SKPaymentTransaction *transaction) {
        
            
            [self configureAsSubscribed];
            [self configureAsLoading:NO];
            [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Payment successfull!",nil) level:kRZErrorMessengerLevelPositive];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [RZErrorMessenger hideAllErrors];
            });

    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [self configureAsLoading:NO];
        [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Payment could not completed!",nil) level:kRZErrorMessengerLevelError];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [RZErrorMessenger hideAllErrors];
        });

        
    }];
}

- (IBAction)buyForAMonth:(id)sender {
        [self configureAsLoading:YES];
    [[RMStore defaultStore] addPayment:k_subscription_Weekly success:^(SKPaymentTransaction *transaction) {
      
            
            [self configureAsSubscribed];
            [self configureAsLoading:NO];
            [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Payment successfull!",nil) level:kRZErrorMessengerLevelPositive];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [RZErrorMessenger hideAllErrors];
            });
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [self configureAsLoading:NO];
        [RZErrorMessenger displayErrorWithTitle:@"" detail:NSLocalizedString(@"Payment could not completed!",nil) level:kRZErrorMessengerLevelError];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [RZErrorMessenger hideAllErrors];
        });

        
    }];
}
@end
