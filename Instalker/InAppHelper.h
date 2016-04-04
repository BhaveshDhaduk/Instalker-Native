//
//  InAppHelper.h
//  Instalker
//
//  Created by umut on 4/4/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RMStore/RMStore.h>
#import "RMStoreKeychainPersistence.h"
#import "RMAppReceipt.h"

@interface InAppHelper : NSObject
+(BOOL)isSubscriptionAvailable;
+(NSDate *)dateOfExpireForSubscription;
@end
