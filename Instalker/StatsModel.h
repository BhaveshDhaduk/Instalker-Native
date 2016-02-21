//
//  StatsModel.h
//  Instalker
//
//  Created by umut on 21/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsModel : NSObject

@property (nonatomic,strong) NSURL *imageURLString;
@property (nonatomic,strong) NSString *textName;
@property (nonatomic,strong) NSNumber *followerCount;
@property (nonatomic,strong) NSNumber *followingCount;
@property (nonatomic,strong) NSNumber *totalLikes;
@property (nonatomic,strong) NSNumber *totalComments;
@property (nonatomic,strong) NSNumber *averageLikes;
@property (nonatomic,strong) NSNumber *averageComments;
@property (nonatomic,strong) NSNumber *totalPostCount;

-(void)setImageURLString:(NSURL *)imageURLString
                textName:(NSString *)textName
           followerCount:(NSNumber *)followerCount
            followsCount:(NSNumber *)followsCount
              totalLikes:(NSNumber *)totalLikes
          totalPostCount:(NSNumber *)totalPostCount
           totalComments:(NSNumber *)totalComments;
@end
