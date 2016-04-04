//
//  InAppHelper.m
//  Instalker
//
//  Created by umut on 4/4/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "InAppHelper.h"

@implementation InAppHelper
#define k_subscription_Weekly @"com.mhs.instalker.premium.week"
#define k_subscription_Monthly @"com.mhs.instalker.premium.1month"
#define k_subscription_3Monthly @"com.mhs.instalker.premium.3month"
#define k_subscription_base @"com.mhs.instalker.premium"

+(BOOL)isSubscriptionAvailable
{
    NSLog(@"Receipt refreshed");
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    NSLog(@"Is subscription 1 active: %d   --- %@", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_Weekly forDate:[NSDate date]],appReceipt.expirationDate);

    if ([appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_Weekly forDate:[NSDate date]])
    {
        return YES;
    }else if([appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_Monthly forDate:[NSDate date]])
    {
        return YES;
    }
    else if([appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_3Monthly forDate:[NSDate date]])
    {
        return YES;
    }else
        return NO;
}

+(NSDate *)dateOfExpireForSubscription
{
    
    NSLog(@"Receipt refreshed");
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    NSLog(@"Is subscription 1 active: %d   --- %@", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_Weekly forDate:[NSDate date]],appReceipt.expirationDate);
    
    if ([appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_Weekly forDate:[NSDate date]])
    {
        return [self lastTransactionFromReceipt:appReceipt identifier:k_subscription_Weekly].subscriptionExpirationDate;
    }else if([appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_Monthly forDate:[NSDate date]])
    {
        return [self lastTransactionFromReceipt:appReceipt identifier:k_subscription_Monthly].subscriptionExpirationDate;
    }
    else if([appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:k_subscription_3Monthly forDate:[NSDate date]])
    {
        return [self lastTransactionFromReceipt:appReceipt identifier:k_subscription_3Monthly].subscriptionExpirationDate;
    }else
        return nil;

}

+(RMAppReceiptIAP *)lastTransactionFromReceipt:(RMAppReceipt *)receipt identifier:(NSString *)productIdentifier
{
    
    RMAppReceiptIAP *lastTransaction = nil;
    
    for (RMAppReceiptIAP *iap in [receipt inAppPurchases])
    {
        if (![iap.productIdentifier isEqualToString:productIdentifier]) continue;
        
        if (!lastTransaction || [iap.subscriptionExpirationDate compare:lastTransaction.subscriptionExpirationDate] == NSOrderedDescending)
        {
            lastTransaction = iap;
        }
    }
    
    return lastTransaction;
    
}

@end
