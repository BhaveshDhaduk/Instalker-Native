//
//  StatsModel.h
//  Instalker
//
//  Created by umut on 21/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsModel : NSObject

@property (nonatomic,strong) NSString *imageURLString;
@property (nonatomic,strong) NSString *textName;
@property (nonatomic,strong) NSNumber *followerCount;
@property (nonatomic,strong) NSNumber *follewingCount;
@property (nonatomic,strong) NSNumber *totalLikes;
@property (nonatomic,strong) NSNumber *averageLikes;
@property (nonatomic,strong) NSNumber *averageComments;
@property (nonatomic,strong) NSNumber *totalPostCount;

@end
