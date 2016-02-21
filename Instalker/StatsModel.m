//
//  StatsModel.m
//  Instalker
//
//  Created by umut on 21/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "StatsModel.h"

@implementation StatsModel

-(id)init{
    self=[super init];
    
    return self;
}

-(void)setImageURLString:(NSURL *)imageURLString
                textName:(NSString *)textName
           followerCount:(NSNumber *)followerCount
            followsCount:(NSNumber *)followsCount
              totalLikes:(NSNumber *)totalLikes
          totalPostCount:(NSNumber *)totalPostCount
           totalComments:(NSNumber *)totalComments
                userName:(NSString *)userName
{
    _imageURLString = imageURLString;
    _textName = textName;
    _followerCount = followerCount;
    _followingCount = followsCount;
    _totalLikes = totalLikes;
    _totalPostCount = totalPostCount;
    _totalComments = totalComments;

    _averageLikes =[NSNumber numberWithInt: [_totalLikes intValue] / [_totalPostCount intValue]];
    _averageComments =[NSNumber numberWithInt: [_totalComments intValue] / [_totalPostCount intValue]];

}

@end
