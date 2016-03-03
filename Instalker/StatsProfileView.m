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
        _labelPostCount.text = [self shortenNumber:model.totalPostCount];
    
    
    [self setNeedsDisplay];
}


#pragma mark - Helpers


-(NSString *)averageLike:(StatsModel *)model
{
    NSString *result;
    NSInteger averageLike=0;
    if (model.totalPostCount != 0) {
        averageLike=model.totalLikes / model.totalPostCount ;
    }
  
    
    result = [self shortenNumber:averageLike];
    
    return result;

}


-(NSString *)averageComments:(StatsModel *)model
{
    NSString *result;
    NSInteger averageComments = 0;
    if (model.totalPostCount) {
        averageComments =model.totalComments  / model.totalPostCount ;
    }
   
    
    result = [self shortenNumber:averageComments];
    
    return result;
    
}

-(NSString *)shortenNumber:(NSInteger )number
{
    NSString *result;
    int  count =(int)number;
    
    
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
