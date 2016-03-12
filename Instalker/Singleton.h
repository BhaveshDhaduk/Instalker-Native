//
//  Singleton.h
//  Instalker
//
//  Created by umut on 1/25/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Singleton : NSObject

+(Singleton*)sharedInstance;

-(id)init;

//shared variables
@property (nonatomic,strong) NSString *accessToken;

@property (nonatomic,strong) NSMutableArray *arraySearchHistory;


@property (nonatomic,strong) UINavigationController *baseNavigationController;

@end
