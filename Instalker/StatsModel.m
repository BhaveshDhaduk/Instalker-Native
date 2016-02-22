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
           followerCount:(NSInteger )followerCount
            followsCount:(NSInteger )followsCount
              totalLikes:(NSInteger )totalLikes
          totalPostCount:(NSInteger )totalPostCount
           totalComments:(NSInteger )totalComments
                userName:(NSString *)userName
{
    _imageURLString = imageURLString;
    _textName = textName;
    _followerCount = followerCount;
    _followingCount = followsCount;
    _totalLikes = totalLikes;
    _totalPostCount = totalPostCount;
    _totalComments = totalComments;
    if (_totalPostCount != 0) {
        _averageLikes =_totalLikes / _totalPostCount ;
        _averageComments =_totalComments  / _totalPostCount;
    }else
    {
        _averageComments = 0;
        _averageLikes = 0;
    }
    
    

}

@end
