//
//  StatsProfileView.m
//  Instalker
//
//  Created by umut on 21/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "StatsProfileView.h"

@implementation StatsProfileView

-(void)configureViews:(StatsModel *)model
{
    _imageViewProfile.imageURL=model.imageURLString;
    _labelName.text = model.textName;
    
    _labelMediaCount.text =[self shortenNumber: model.totalPostCount];
    _labelFollewsCount.text = [self shortenNumber:model.followerCount];
    _labelFollowingCount.text = [self shortenNumber:model.followingCount];
    _labelTotalLikes.text = [self shortenNumber:model.totalLikes];
    _labelAveragePosts.text = [self averageLike:model];
    _labelAverageComments.text = [self averageComments:model];
    [self setNeedsDisplay];
}


#pragma mark - Helpers


-(NSString *)averageLike:(StatsModel *)model
{
    NSString *result;
    int averageLike =[model.totalLikes intValue] / [model.totalPostCount intValue];
    
    result = [self shortenNumber:[NSNumber numberWithInt:averageLike]];
    
    return result;

}


-(NSString *)averageComments:(StatsModel *)model
{
    NSString *result;
    int averageComments =[model.totalComments intValue] / [model.totalPostCount intValue];
    
    result = [self shortenNumber:[NSNumber numberWithInt:averageComments]];
    
    return result;
    
}

-(NSString *)shortenNumber:(NSNumber *)number
{
    NSString *result;
    int count = [number intValue];
    
    
    if (count> 999999) {
        int left = count / 1000000;
        int right = count %1000000;
        right = right / 100000;
        result = [NSString stringWithFormat:@"%d.%dM",left,right];
        
        
    }else if(count>9999)
    {
        int right = count / 1000;
        result = [NSString stringWithFormat:@"%dK",right];
        
    }else if(count > 999)
    {
        int left = count / 1000;
        int right = count %1000;
        right = right / 100;
        result = [NSString stringWithFormat:@"%d.%dK",left,right];
        
    }else
    {
    
        result = [NSString stringWithFormat:@"%d",count];
    
    }
    
    return result;
}



@end
